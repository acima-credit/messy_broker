# frozen_string_literal: true

require 'rspec/core/shared_context'
require 'faker'
require 'field_struct/avro_schema'

module FunctionalHelpers
  class Friend < FieldStruct.mutable
    required :name, :string
    optional :age, :integer
    optional :balance_owed, :currency, default: 0.0
    optional :gamer_level, :integer, enum: [1, 2, 3], default: -> { 1 }
    optional :zip_code, :string, format: /\A[0-9]{5}?\z/

    def topic_key
      format '%s', name
    end
  end

  extend RSpec::Core::SharedContext

  def build_friend_attrs(attrs = {})
    attrs[:name] ||= Faker::Name.name
    attrs[:age] ||= Faker::Number.between from: 10, to: 85
    attrs[:balance_owed] ||= Faker::Number.between(from: 0.0, to: 150.0).round(2)
    attrs[:gamer_level] ||= Faker::Number.between(from: 1, to: 3)
    attrs[:zip_code] ||= Faker::Address.zip_code[0, 5]
    attrs
  end

  def build_friend(attrs = {})
    Friend.new build_friend_attrs(attrs)
  end

  def build_record_opts(instance, format: 'avro', app_name: 'testing', app_version: 1)
    {
      topic: topic,
      key: instance.respond_to?(:topic_key) ? instance.topic_key : nil,
      schema: instance.class.metadata.to_avro_json,
      headers: {
        encode_format: format,
        app_name: app_name,
        app_version: app_version,
        schema_name: instance.class.metadata.name,
        schema_version: instance.class.metadata.version
      }
    }
  end
end

RSpec.configure do |config|
  config.include FunctionalHelpers
end
