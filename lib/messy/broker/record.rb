# frozen_string_literal: true

module Messy
  module Broker
    class Record
      class Metadata
        def self.from(record)
          new checksum: record.checksum,
              offset: record.offset,
              partition: record.partition,
              timestamp: record.timestamp,
              topic: record.topic
        end

        attr_reader :checksum, :offset, :partition, :timestamp, :topic

        def initialize(options = {})
          @checksum  = options[:checksum]&.to_s
          @offset    = options[:offset]&.to_i
          @partition = options[:partition]&.to_i
          @timestamp = options[:timestamp]&.to_s
          @topic     = options[:topic]&.to_s
        end

        def to_hash
          {
            checksum: checksum,
            offset: offset,
            partition: partition,
            timestamp: timestamp,
            topic: topic
          }
        end
      end

      def self.from(record)
        new checksum: record.checksum,
            key: record.key,
            offset: record.offset,
            partition: record.partition,
            timestamp: record.timestamp,
            topic: record.topic,
            value: record.value,
            headers: record.headers
      end

      attr_reader :checksum, :key, :offset, :partition, :timestamp, :topic, :value, :headers

      def initialize(options = {})
        @checksum  = options[:checksum]&.to_s
        @key       = options[:key]&.to_s
        @offset    = options[:offset]&.to_i
        @partition = options[:partition]&.to_i
        @timestamp = options[:timestamp]&.to_s
        @topic     = options[:topic]&.to_s
        @value     = options[:value].to_s
        @headers   = build_headers options[:headers]
      end

      def parsed_value
        parse_avro(value) || parse_json(value) || parse_unknown
      end

      def to_hash
        {
          value: parsed_value,
          headers: headers,
          meta: {
            checksum: checksum,
            key: key,
            offset: offset,
            partition: partition,
            timestamp: timestamp,
            topic: topic
          }
        }
      end

      private

      def build_headers(original_headers)
        return original_headers if original_headers.is_a?(Hash)

        hsh = {}
        return hsh if original_headers.nil?

        original_headers.each { |header| hsh[header.key] = String.from_java_bytes header.value }
        hsh
      end

      def parse_json(body)
        json_byte = body[0, 1]
        return unless json_byte == '{'

        JSON.parse(body)
      rescue JSON::JSONError
        {}
      end

      def parse_avro(body)
        stream = StringIO.new body.to_s
        magic_byte = stream.read(1)
        return unless magic_byte == MAGIC_BYTE

        schema_id = stream.read(4).unpack1('N')
        schema = Broker.schema_registry.get_by_id schema_id
        raise schema if schema.is_a?(Error)

        avro_record = stream.read
        converter = JsonAvroConverter.new
        json = converter.convertToJson(avro_record.to_java_bytes, schema.schema).to_s
        parse_json json
      rescue StandardError
        {}
      end

      def parse_unknown
        {}
      end
    end
  end
end
