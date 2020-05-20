# frozen_string_literal: true

module Messy
  module Broker
    module Schemas
      class Registry
        attr_reader :ids, :subject_ids, :subject_schema_versions

        def initialize(url = Broker.schema_registry_url, max = 10_000)
          @cache = CACHED_SCHEMA_REGISTRY_CLASS.new url, max
          @ids = {}
          @subject_ids = {}
          @subject_versions = {}
          @subject_schema_versions = {}
          @lock = Concurrent::ReadWriteLock.new
        end

        # @param [String] subject
        # @param [String] schema_str
        # @return [Messy::Broker::Schemas::Schema, Messy::Broker::Error]
        def find_or_register(subject, schema_str, schema_version)
          found_id = @subject_schema_versions.dig(subject, schema_version)
          return @ids[found_id] if @ids.key?(found_id)

          register subject, schema_str
        end

        # int register(String subject, ParsedSchema schema)
        def register(subject, schema_str)
          safe_rest_call do
            schema = parsed_schema schema_str
            id = @cache.register subject, schema
            if id.nil? || id.is_a?(Error)
              id
            else
              get_full subject, id
            end
          end
        end

        def get_full(subject, id)
          safe_rest_call do
            version = get_versions_by_id(id, subject)&.first
            return version if version.is_a?(Error)

            get_by_version subject, version
          end
        end

        # ParsedSchema getSchemaById(int id)
        def get_by_id(id)
          safe_rest_call do
            schema = @cache.getSchemaById(id)
            cache_id id: id, schema: schema.raw_schema
          end
        end

        # ParsedSchema getSchemaByIdFromRegistry(int id)
        def get_by_id_from_registry(id)
          safe_rest_call do
            @cache.getSchemaByIdFromRegistry(id).tap do |schema|
              cache_id id: id, schema: schema.raw_schema
            end
          end
        end

        # ParsedSchema getSchemaBySubjectAndId(String subject, int id)
        def get_by_subject_and_id(subject, id)
          safe_rest_call do
            schema = @cache.getSchemaBySubjectAndId subject, id
            cache_id id: id, subject: subject, schema: schema.raw_schema
          end
        end

        # Collection<String> getAllSubjectsById(int id)
        def get_subjects_by_id(id)
          safe_rest_call { @cache.getAllSubjectsById(id).to_a.sort }
        end

        # Collection<SubjectVersion> getAllVersionsById(int id)
        def get_versions_by_id(id, subject = nil)
          safe_rest_call do
            found = @cache.getAllVersionsById(id).map { |x| SubjectVersion.from x }
            subject ? found.select { |x| x.subject == subject }.map(&:version) : found
          end
        end

        # Schema getByVersion(String subject, int version, boolean lookupDeletedSchema)
        def get_by_version(subject, version, lookup_deleted = false)
          safe_rest_call do
            found = @cache.getByVersion(subject, version, lookup_deleted)
            return found if found.is_a?(Error)

            cache_id full: Schema.from(found)
          end
        end

        # SchemaMetadata getSchemaMetadata(String subject, int version)
        def get_metadata(subject, version)
          safe_rest_call do
            SchemaMetadata.from(@cache.getSchemaMetadata(subject, version)).tap do |meta|
              cache_id id: meta.id, subject: subject, schema: meta.schema, version: meta.version
            end
          end
        end

        # SchemaMetadata getLatestSchemaMetadata(String subject)
        def get_latest_metadata(subject)
          safe_rest_call do
            SchemaMetadata.from @cache.getLatestSchemaMetadata(subject).tap do |meta|
              cache_id id: meta.id, subject: subject, schema: meta.schema, version: meta.version
            end
          end
        end

        # int getVersion(String subject, ParsedSchema schema)
        def get_version(subject, schema_str)
          safe_rest_call { @cache.getVersion subject, parsed_schema(schema_str) }
        end

        # List<Integer> getAllVersions(String subject)
        def get_versions(subject)
          safe_rest_call { @cache.getAllVersions(subject).to_a }
        end

        # int getId(String subject, ParsedSchema schema)
        def get_id(subject, schema_str)
          safe_rest_call do
            schema = parsed_schema(schema_str)
            @cache.getId(subject, schema).tap do |id|
              cache_id id: id, subject: subject, schema: schema
            end
          end
        end

        # List<Integer> deleteSubject(String subject)
        def delete_subject(subject)
          safe_rest_call do
            @cache.deleteSubject(subject).to_a.tap { delete_cache subject: subject }
          end
        end

        # Integer deleteSchemaVersion(String subject, String version)
        def delete_schema_version(subject, version)
          safe_rest_call do
            @cache.deleteSchemaVersion(subject, version).tap do
              delete_cache subject: subject, version: version
            end
          end
        end

        # boolean testCompatibility(String subject, ParsedSchema schema)
        def test_compatibility(subject, schema_str)
          safe_rest_call { @cache.testCompatibility subject, parsed_schema(schema_str) }
        end

        # String updateCompatibility(String subject, String compatibility)
        def update_compatibility(subject, compatibility)
          safe_rest_call { @cache.updateCompatibility subject, compatibility }
        end

        # String getCompatibility(String subject)
        def get_compatibility(subject)
          safe_rest_call { @cache.getCompatibility subject }
        end

        # String setMode(String mode)
        # String setMode(String mode, String subject)
        def set_mode(mode, subject = nil)
          safe_rest_call { subject ? @cache.setMode(mode, subject) : @cache.setMode(mode) }
        end

        # String getMode()
        # String getMode(String subject)
        def get_mode(subject = nil)
          safe_rest_call { subject ? @cache.getMode(subject) : @cache.getMode }
        end

        # Collection<String> getAllSubjects()
        def subjects
          safe_rest_call do
            @cache.getAllSubjects.map(&:to_s).sort { |a, b| a.downcase <=> b.downcase }
          end
        end

        # void reset()
        def reset
          safe_rest_call do
            @cache.reset.tap do
              @ids = {}
              @subject_ids = {}
              @subject_versions = {}
              @subject_schema_versions = {}
            end
          end
        end

        private

        def safe_rest_call(&blk)
          blk.call
        rescue REST_ERROR_CLASS => e
          RestError.new(e)
        rescue Exception => e
          Error.new(e)
        end

        def cache_id(opts = {})
          found = nil
          @lock.with_write_lock do
            found = cache_ids opts
            cache_subject_ids found
            cache_subject_versions found
            cache_subject_schema_versions found
          end
          found
        end

        def cache_ids(opts = {})
          if opts[:full]
            @ids[opts[:full].id] = opts[:full]
          else
            (@ids[id] ||= Schema.new).tap do |found|
              found.assign_attributes_when_nil opts
            end
          end
        end

        def cache_subject_ids(schema)
          return unless schema.subject && schema.id

          (@subject_ids[schema.subject] ||= []).tap do |ary|
            ary.push(schema.id).sort! unless ary.include?(schema.id)
          end
        end

        def cache_subject_versions(schema)
          return unless schema.subject && schema.version && schema.id

          (@subject_versions[schema.subject] ||= {}).tap do |hsh|
            hsh[schema.version] = schema.id unless hsh.key?(schema.version)
          end
        end

        def cache_subject_schema_versions(schema)
          return unless schema.subject && schema.schema_version && schema.id

          (@subject_schema_versions[schema.subject] ||= {}).tap do |hsh|
            hsh[schema.schema_version] = schema.id unless hsh.key?(schema.schema_version)
          end
        end

        def delete_cache(subject: nil, version: nil)
          @ids.each do |id, schema|
            if subject && version
              @ids.delete(id) if schema.subject == subject && schema.version == version
            elsif subject
              @ids.delete(id) if schema.subject == subject
            end
          end
        end

        # @param [String] str
        def parsed_schema(str)
          Schema.parse_schema_str str
        end
      end
    end
  end
end
