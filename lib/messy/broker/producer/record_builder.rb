# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      class RecordBuilder
        def self.build(*args)
          new.build(*args)
        end

        # Builds a representation of the value in Avro or JSON
        #
        # @param [Hash] original_value
        # @param [Messy::Broker::Producer::RecordOptions] record_opts
        # @return [Java::OrgApacheKafkaClientsProducer::ProducerRecord, Messy::Broker::Error]
        # @raise Messy::Broker::Error
        def build(original_value, record_opts)
          value = ValueBuilder.build original_value, record_opts
          return value if value.is_a?(Error)

          record = build_with_all(value, record_opts) ||
                   build_with_topic_partition_key(value, record_opts) ||
                   build_with_topic_key(value, record_opts) ||
                   build_with_topic(value, record_opts)
          raise Error, 'invalid record options' unless record

          record_opts.headers&.to_props&.each { |k, v| record.headers.add k, v.to_java_bytes }

          record
        rescue Exception => e
          Error.new(e)
        end

        private

        # @param [Hash] value
        # @param [Messy::Broker::Producer::RecordOptions] opts
        # @return [FalseClass, Java::OrgApacheKafkaClientsProducer::ProducerRecord]
        def build_with_all(value, opts)
          return false unless opts.has?(:topic, :partition, :timestamp, :key)

          ProducerRecord.new opts.topic, opts.partition, opts.timestamp, opts.key, value
        end

        # @param [Hash] value
        # @param [Messy::Broker::Producer::RecordOptions] opts
        # @return [FalseClass, Java::OrgApacheKafkaClientsProducer::ProducerRecord]
        def build_with_topic_partition_key(value, opts)
          return false unless opts.has?(:topic, :partition, :key)

          ProducerRecord.new opts.topic, opts.partition, opts.key, value
        end

        # @param [Hash] value
        # @param [Messy::Broker::Producer::RecordOptions] opts
        # @return [FalseClass, Java::OrgApacheKafkaClientsProducer::ProducerRecord]
        def build_with_topic_key(value, opts)
          return false unless opts.has?(:topic, :key)

          ProducerRecord.new opts.topic, opts.key, value
        end

        # @param [Hash] value
        # @param [Messy::Broker::Producer::RecordOptions] opts
        # @return [FalseClass, Java::OrgApacheKafkaClientsProducer::ProducerRecord]
        def build_with_topic(value, opts)
          return false unless opts.has?(:topic)

          ProducerRecord.new opts.topic, value
        end
      end
    end
  end
end
