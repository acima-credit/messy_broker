# frozen_string_literal: true

module Messy
  module Broker
    module Schemas
      # io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient
      CACHED_SCHEMA_REGISTRY_CLASS = Java::IoConfluentKafkaSchemaregistryClient::CachedSchemaRegistryClient
      # org.apache.avro.Schema.Parser
      AvroSchemaParser = Java::OrgApacheAvro::Schema::Parser
      # io.confluent.kafka.schemaregistry.client.rest.exceptions.RestClientException
      REST_ERROR_CLASS = Java::IoConfluentKafkaSchemaregistryClientRestExceptions::RestClientException

      # tech.allegro.schema.json2avro.converter.JsonAvroConverter
      JsonAvroConverter = Java::TechAllegroSchemaJson2avroConverter::JsonAvroConverter
      # tech.allegro.schema.json2avro.converter.AvroConversionException
      JsonAvroConversionException = Java::TechAllegroSchemaJson2avroConverter::AvroConversionException
    end
  end
end
