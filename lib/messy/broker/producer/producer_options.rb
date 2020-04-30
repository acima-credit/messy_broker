# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      class ProducerOptions < FieldStruct.flexible
        extras :add

        optional :key_type, :string, default: 'string', enum: SERIALIZERS.keys
        optional :value_type, :string, default: 'avro', enum: SERIALIZERS.keys

        optional :bootstrap_servers, :string, default: -> { Broker.bootstrap_servers }
        optional :schema_registry_url, :string, default: -> { Broker.schema_registry_url }
        optional :acks, :string, default: 'all'
        optional :retries, :integer, default: 1_000
        optional :enable_idempotence, :string, default: 'true', enum: %w[true false]

        def to_hash
          super.tap do |hsh|
            hsh['key_serializer'] = SERIALIZERS.fetch hsh.delete('key_type'), DEFAULT_SERIALIZER
            hsh['value_serializer'] = SERIALIZERS.fetch hsh.delete('value_type'), DEFAULT_SERIALIZER
          end
        end

        def to_properties(opts = {})
          Broker::Mixin.java_props to_hash.update(opts)
        end
      end
    end
  end
end
