# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      # org.apache.kafka.clients.producer.KafkaProducer
      KafkaProducer = Java::OrgApacheKafkaClientsProducer::KafkaProducer
      # org.apache.kafka.clients.producer.ProducerRecord
      ProducerRecord = Java::OrgApacheKafkaClientsProducer::ProducerRecord
      # org.apache.kafka.clients.producer.internals.FutureRecordMetadata
      FutureRecordMetadata = Java::OrgApacheKafkaClientsProducerInternals::FutureRecordMetadata

      # org.apache.kafka.common.serialization.StringSerializer
      StringSerializer = Java::OrgApacheKafkaCommonSerialization::StringSerializer
      # io.confluent.kafka.serializers.KafkaAvroSerializer
      AvroSerializer = Java::IoConfluentKafkaSerializers::KafkaAvroSerializer

      SERIALIZERS = {
        'string' => StringSerializer,
        'json' => StringSerializer,
        'avro' => AvroSerializer
      }.freeze

      # org.apache.avro.Schema.Parser
      AvroSchemaParser = Java::OrgApacheAvro::Schema::Parser

      # java.io.ByteArrayOutputStream
      ByteArrayOutputStream = Java::JavaIo::ByteArrayOutputStream
      # org.apache.avro.specific.SpecificDatumWriter
      AvroDatumWriter = Java::OrgApacheAvroSpecific::SpecificDatumWriter
      # org.apache.avro.io.EncoderFactory
      AvroEncoderFactory = Java::OrgApacheAvroIo::EncoderFactory

      java_import 'org.apache.kafka.clients.producer.Callback'

      include Mixin

      # java.util.concurrent.TimeUnit
      TimeUnit = Java::JavaUtilConcurrent::TimeUnit
      CLOSE_TIMEOUT_MS = 500

      TOPICS_REGEXP = /\A[\w\-.,]+\z/.freeze
      NAME_REGEXP   = /\A[\w\-.]+\z/.freeze
    end
  end
end
