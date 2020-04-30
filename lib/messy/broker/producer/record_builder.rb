# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      class RecordBuilder
        def self.build(*args)
          new.build(*args)
        end

        def build(original_value, record_opts, value_type)
          value, error = build_value original_value, record_opts, value_type
          return error unless error.nil?

          record = build_with_all(value, record_opts) ||
                   build_with_topic_partition_key(value, record_opts) ||
                   build_with_topic_key(value, record_opts) ||
                   build_with_topic(value, record_opts)
          record_opts.headers&.to_props&.each { |k, v| record.headers.add k, v.to_java_bytes }

          [record, nil]
        rescue Exception => e
          [nil, Error.new(e)]
        end

        private

        def build_value(value, opts, value_type)
          case value_type
          when 'avro'
            build_avro_value value, opts
          else
            value.to_s
          end
        end

        def build_avro_value(value, opts)
          raise 'missing schema' unless opts.schema.present?
          raise "invalid value [#{value.class.name}]" unless value.is_a?(Hash)

          parser = AVRO_SCHEMA_PARSER_CLASS.new
          avro_schema = parser.parse opts.schema

          convert_to_avro_record avro_schema, value
        end

        def convert_to_avro_record(avro_schema, value)
          converter = JSON_AVRO_CONVERTER_CLASS.new
          json_bytes = value.to_json.to_java_bytes
          converter.convertToGenericDataRecord json_bytes, avro_schema
        rescue JSON_AVRO_CONVERTER_ERROR => e
          Error.new(e)
        rescue Exception => e
          Error.new(e)
        end

        def build_with_all(value, opts)
          return false unless opts.has?(:topic, :partition, :timestamp, :key)

          PRODUCER_RECORD_CLASS.new opts.topic, opts.partition, opts.timestamp, opts.key, value
        end

        def build_with_topic_partition_key(value, opts)
          return false unless opts.has?(:topic, :partition, :key)

          PRODUCER_RECORD_CLASS.new opts.topic, opts.partition, opts.key, value
        end

        def build_with_topic_key(value, opts)
          return false unless opts.has?(:topic, :key)

          PRODUCER_RECORD_CLASS.new opts.topic, opts.key, value
        end

        def build_with_topic(value, opts)
          return false unless opts.has?(:topic)

          PRODUCER_RECORD_CLASS.new opts.topic, value
        end
      end
    end
  end
end
