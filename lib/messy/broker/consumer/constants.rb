# frozen_string_literal: true

module Messy
  module Broker
    class Consumer
      CONSUMER_CLASS = Java::OrgApacheKafkaClientsConsumer::KafkaConsumer # org.apache.kafka.clients.consumer.KafkaConsumer

      STRING_DESERIALIZER_CLASS = Java::OrgApacheKafkaCommonSerialization::StringDeserializer # org.apache.kafka.common.serialization.StringDeserializer
      AVRO_DESERIALIZER_CLASS   = Java::IoConfluentKafkaSerializers::KafkaAvroDeserializer # io.confluent.kafka.serializers.KafkaAvroDeserializer

      DESERIALIZERS = {
        'string' => STRING_DESERIALIZER_CLASS.java_class.name,
        'avro' => AVRO_DESERIALIZER_CLASS.java_class.name
      }.freeze
      DEFAULT_DESERIALIZER = DESERIALIZERS['avro']

      OFFSET_RESETS = %w[latest earliest none].freeze
      MAX_POLL_DEFAULT = 10
      ENABLE_AUTO_COMMIT = true
      POLL_TIMEOUT_MS = 1_500
      AUTO_COMMIT_INTERVAL_MS = 1_500
      SESSION_TIMEOUT_MS = 30_000

      CLOSE_TIMEOUT_MS = 500
      TIME_UNIT = Java::JavaUtilConcurrent::TimeUnit # java.util.concurrent.TimeUnit

      TOPICS_REGEXP = /\A[\w\-.,]+\z/.freeze
      NAME_REGEXP   = /\A[\w\-.]+\z/.freeze

      DURATION = Java::JavaTime::Duration # java.time.Duration
    end
  end
end
