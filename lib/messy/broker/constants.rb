# frozen_string_literal: true

module Messy
  module Broker
    MAGIC_BYTE = [0].pack('C').freeze

    # tech.allegro.schema.json2avro.converter.JsonAvroConverter
    JsonAvroConverter = Java::TechAllegroSchemaJson2avroConverter::JsonAvroConverter
    # tech.allegro.schema.json2avro.converter.AvroConversionException
    JsonAvroConversionException = Java::TechAllegroSchemaJson2avroConverter::AvroConversionException
  end
end
