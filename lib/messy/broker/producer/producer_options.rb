# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      class ProducerOptions < FieldStruct.flexible
        extras :add

        required :bootstrap_servers, :string, default: -> { Broker.bootstrap_servers }
        required :schema_registry_url, :string, default: -> { Broker.schema_registry_url }
        required :key_type, :string, default: 'string', enum: SERIALIZERS.keys
        required :value_type, :string, default: 'avro', enum: SERIALIZERS.keys
        optional :acks, :string, default: 'all'
        optional :retries, :integer, default: 1_000
        optional :enable_idempotence, :string, default: 'true', enum: %w[true false]

        def to_hash
          super.tap do |hsh|
            hsh['key_serializer'] = serializer_for hsh, 'key_type', 'string'
            hsh['value_serializer'] = serializer_for hsh, 'value_type', 'avro'
          end
        end

        def to_properties(opts = {})
          Broker::Mixin.java_props to_hash.update(opts)
        end

        private

        def serializer_for(hsh, key, default)
          SERIALIZERS.fetch(hsh.delete(key), default).java_class.name
        end
      end
    end
  end
end
