# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      class ValueBuilder
        class TypeBuilder
          def self.build(*args)
            new.build(*args)
          end
        end

        class AvroValueBuilder < TypeBuilder
          # Builds an Avro record marked by the magic byte, the schema_id and a binary representation of the data
          #
          # @param [Hash] value
          # @param [Messy::Broker::Producer::RecordOptions] opts
          # @return [byte[]]
          # @raise Error
          def build(value, opts)
            raise Error, "invalid value [#{value.class.name}]" unless value.is_a?(Hash)

            schema = get_full_schema opts
            raise schema if schema.is_a?(Error)
            raise Error, 'could not find full schema' if schema.nil?
            raise Error, 'could not parse full schema' unless schema.parsed_schema

            schema_type = schema.parsed_schema.type.to_s
            raise Error, "invalid schema type [#{schema_type}]" unless schema_type == 'RECORD'

            convert_to_avro_value schema.parsed_schema, value
          end

          # @param [Messy::Broker::Producer::RecordOptions] opts
          # @return [Messy::Broker::Schemas::Registry::Schema]
          def get_full_schema(opts)
            subject = opts.topic
            subject = format('%s-value', subject) unless subject.end_with?('-value')
            get_full_schema_by_id(subject, opts.schema_id) ||
              get_full_schema_by_schema(subject, opts.schema, opts.schema_version)
          end

          # @param [String] subject
          # @param [Integer] schema_id
          # @return [nil, Messy::Broker::Schemas::Registry::Schema]
          def get_full_schema_by_id(subject, schema_id)
            return unless schema_id

            Schemas.registry.get_full subject, schema_id
          end

          # @param [String] subject
          # @param [String] schema_str
          # @param [String] schema_version
          # @return [nil, Messy::Broker::Schemas::Registry::Schema]
          def get_full_schema_by_schema(subject, schema_str, schema_version)
            return unless schema_str

            Schemas.registry.find_or_register subject, schema_str, schema_version
          end

          # @param [Java::OrgApacheAvro::Schema] avro_schema
          # @param [Hash] value
          # @return [byte[]]
          def convert_to_avro_value(avro_schema, value)
            converter = JsonAvroConverter.new
            json_bytes = value.to_json.to_java_bytes
            converter.convertToGenericDataRecord json_bytes, avro_schema
          rescue Exception => e
            Error.new(e)
          end
        end

        class StringValueBuilder < TypeBuilder
          # Builds a STRING representation of the data
          #
          # @param [Hash] value
          # @param [Messy::Broker::Producer::RecordOptions] opts
          # @return [String]
          # @raise Error
          def build(value, _opts)
            value.to_s
          end
        end

        # @param [Hash] value
        # @param [Messy::Broker::Producer::RecordOptions] opts
        def self.build(value, opts)
          new.build value, opts
        end

        # @param [Hash] value
        # @param [Messy::Broker::Producer::RecordOptions] opts
        def build(value, opts)
          case opts.encode_format
          when 'avro'
            AvroValueBuilder.build(value, opts)
          when 'string'
            StringValueBuilder.build(value, opts)
          else
            Error.new("invalid encoding format [#{opts.encode_format}]")
          end
        rescue Exception => e
          Error.new(e)
        end
      end
    end
  end
end
