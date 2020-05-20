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

  def debug?
    ENV.fetch('DEBUG', 'false') == 'true'
  end

  def debug_label(name)
    return unless debug?

    puts " [ #{name} ] ".center(90, '=')
  end

  def debug_var(name, value)
    return unless debug?

    puts format('>> %s | (%s) %s', name, value.class.name, value.to_yaml)
  end

  def debug_error(found)
    return unless found.is_a? Exception

    puts "Exception: #{found.class.name} : #{found.message}\n  #{found.backtrace[0, 10].join("\n  ")}"
  end

  extend RSpec::Core::SharedContext

  let(:app_name) { 'test_app' }
  let(:app_version) { 1 }
  let(:instance_class) { FunctionalHelpers::Friend }
  let(:metadata) { instance_class.metadata }

  let(:producer_opts) do
    {
      key_type: 'string',
      value_type: encode_format
    }
  end
  let(:producer) { Messy::Broker.build_producer producer_opts }

  let(:cons_opts) do
    {
      key_type: 'string',
      value_type: encode_format,
      max_poll_records: 100,
      auto_offset_reset: 'earliest',
      topics: [topic],
      group_id: "#{topic}-group"
    }
  end
  let(:consumer) { Messy::Broker.build_consumer cons_opts }
  let(:extra_consumer) { Messy::Broker.build_consumer cons_opts }

  let(:qty) { 25 }
  let(:instances) { qty.times.map { build_friend } }
  let(:payloads) { instances.map(&:to_hash) }
  let(:messages) { payloads.map { |x| [x, key: x['name']] } }

  let(:extra_qty) { 10 }
  let(:extra_instances) { extra_qty.times.map { build_friend } }
  let(:extra_payloads) { extra_instances.map(&:to_hash) }
  let(:extra_messages) { extra_payloads.map { |x| [x, key: x['name']] } }

  let(:reg_schema) { Messy::Broker.schema_registry.find_or_register format('%s-value', topic), metadata.to_avro_json, metadata.version }

  let(:record_opts) do
    {
      topic: topic,
      schema: metadata.to_avro_json,
      headers: {
        encode_format: encode_format,
        app_name: app_name,
        app_version: app_version,
        schema_name: metadata.name,
        schema_version: metadata.version
      }
    }
  end
  let(:no_schema_record_opts) { record_opts.except :schema }
  let(:extra_record_opts) do
    {
      topic: topic,
      headers: {
        encode_format: encode_format,
        app_name: app_name,
        app_version: app_version,
        schema_id: reg_schema.id
      }
    }
  end

  let(:topic) { format 'friends-%s-%s', encode_format, SecureRandom.uuid[0, 5] }
end

RSpec.configure do |config|
  config.include FunctionalHelpers, :functional
end
