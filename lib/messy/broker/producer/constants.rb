# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      PRODUCER_CLASS = Java::OrgApacheKafkaClientsProducer::KafkaProducer # org.apache.kafka.clients.producer.KafkaProducer
      PRODUCER_CONFIG_CLASS = Java::OrgApacheKafkaClientsProducer::ProducerConfig # org.apache.kafka.clients.producer.ProducerConfig
      PRODUCER_RECORD_CLASS = Java::OrgApacheKafkaClientsProducer::ProducerRecord # org.apache.kafka.clients.producer.ProducerRecord
      FUTURE_RECORD_CLASS = Java::OrgApacheKafkaClientsProducerInternals::FutureRecordMetadata # org.apache.kafka.clients.producer.internals.FutureRecordMetadata

      STRING_SERIALIZER_CLASS   = Java::OrgApacheKafkaCommonSerialization::StringSerializer # org.apache.kafka.common.serialization.StringSerializer
      AVRO_SERIALIZER_CLASS     = Java::IoConfluentKafkaSerializers::KafkaAvroSerializer # io.confluent.kafka.serializers.KafkaAvroSerializer

      AVRO_SCHEMA_CLASS         = Java::OrgApacheAvro::Schema # org.apache.avro.Schema
      AVRO_SCHEMA_PARSER_CLASS  = Java::OrgApacheAvro::Schema::Parser # org.apache.avro.Schema.Parser
      AVRO_GENERIC_DATA_CLASS   = Java::OrgApacheAvroGeneric::GenericData #  org.apache.avro.generic.GenericData
      AVRO_GENERIC_RECORD_CLASS = Java::OrgApacheAvroGeneric::GenericRecord # org.apache.avro.generic.GenericRecord

      # tech.allegro.schema.json2avro.converter.JsonAvroConverter
      JSON_AVRO_CONVERTER_CLASS = Java::TechAllegroSchemaJson2avroConverter::JsonAvroConverter
      # tech.allegro.schema.json2avro.converter.AvroConversionException
      JSON_AVRO_CONVERTER_ERROR = Java::TechAllegroSchemaJson2avroConverter::AvroConversionException

      java_import 'org.apache.kafka.clients.producer.Callback'

      include Mixin

      SERIALIZERS = {
        'string' => STRING_SERIALIZER_CLASS.java_class.name,
        'avro' => AVRO_SERIALIZER_CLASS.java_class.name
      }.freeze
      DEFAULT_SERIALIZER = SERIALIZERS['string']

      CLOSE_TIMEOUT_MS = 500
      TIME_UNIT = Java::JavaUtilConcurrent::TimeUnit # java.util.concurrent.TimeUnit

      TOPICS_REGEXP = /\A[\w\-.,]+\z/.freeze
      NAME_REGEXP   = /\A[\w\-.]+\z/.freeze

      DURATION = Java::JavaTime::Duration # java.time.Duration
    end
  end
end
