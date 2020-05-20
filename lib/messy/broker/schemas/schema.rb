# frozen_string_literal: true

module Messy
  module Broker
    module Schemas
      class Schema < FieldStruct.mutable
        def self.from(original)
          new subject: original.subject,
              version: original.version,
              id: original.id,
              schema_type: original.schema_type,
              references: original.references.map { |x| SchemaReference.from x },
              schema: original.schema
        end

        required :subject, :string
        required :version, :integer
        required :id, :integer
        optional :schema_type, :string
        optional :references, :array, of: SchemaReference
        required :schema, :string
        optional :schema_version, :string

        def schema=(value)
          if value.is_a?(String)
            @attributes.write_from_user 'schema', value
          elsif value.respond_to?(:raw_schema)
            self.schema = value.raw_schema
          elsif value.respond_to?(:schema)
            self.schema = value.schema
          elsif value.respond_to?(:to_s)
            self.schema = value.to_s
          end
        end

        def schema_version
          return super if super
          return nil if parsed_schema.nil?

          schema_doc = parsed_schema.is_union? ? parsed_schema.types.last.doc : parsed_schema.doc
          self.schema_version = get_schema_version_from_doc schema_doc
        end

        def parsed_schema
          return nil unless schema

          @parsed_schema ||= self.class.parse_schema_str schema
        end

        def self.parse_schema_str(str)
          AvroSchemaParser.new.parse str
        end

        private

        def get_schema_version_from_doc(str)
          match = str.match(/\| version ([0-9a-f]+)\z/)
          match ? match[1] : nil
        end
      end
    end
  end
end
