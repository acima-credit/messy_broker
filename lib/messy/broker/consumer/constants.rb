# frozen_string_literal: true

module Messy
  module Broker
    class Consumer
      # org.apache.kafka.clients.consumer.KafkaConsumer
      KafkaConsumer = Java::OrgApacheKafkaClientsConsumer::KafkaConsumer

      # org.apache.kafka.common.serialization.StringDeserializer
      STRING_DESERIALIZER_CLASS = Java::OrgApacheKafkaCommonSerialization::StringDeserializer
      # org.apache.kafka.common.serialization.StringDeserializer
      StringDeserializer = Java::OrgApacheKafkaCommonSerialization::StringDeserializer
      # io.confluent.kafka.serializers.KafkaAvroSerializer
      AvroDeserializer = Java::IoConfluentKafkaSerializers::KafkaAvroDeserializer
      # io.confluent.kafka.serializers.KafkaJsonSerializer
      JsonSchemaDeserializer = Java::IoConfluentKafkaSerializers::KafkaJsonDeserializer

      DESERIALIZERS = {
        'string' => StringDeserializer,
        'avro' => AvroDeserializer
      }.freeze

      OFFSET_RESETS = %w[latest earliest none].freeze
      MAX_POLL_DEFAULT = 10
      ENABLE_AUTO_COMMIT = true
      POLL_TIMEOUT_MS = 1_500
      AUTO_COMMIT_INTERVAL_MS = 1_500
      SESSION_TIMEOUT_MS = 30_000

      CLOSE_TIMEOUT_MS = 500
      TimeUnit = Java::JavaUtilConcurrent::TimeUnit # java.util.concurrent.TimeUnit

      TOPICS_REGEXP = /\A[\w\-.,]+\z/.freeze
      NAME_REGEXP   = /\A[\w\-.]+\z/.freeze
    end
  end
end
