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
        JSON.parse(value)
      rescue JSONError
        {}
      end

      def to_hash
        {
          body: value,
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
    end
  end
end
