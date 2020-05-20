# frozen_string_literal: true

module Messy
  module Broker
    class Consumer
      class ConsumerOptions < FieldStruct.flexible
        extras :add

        required :topics, :array, of: :string

        optional :bootstrap_servers, :string, default: -> { Broker.bootstrap_servers }
        required :schema_registry_url, :string, default: -> { Broker.schema_registry_url }
        required :key_type, :string, default: 'string', enum: DESERIALIZERS.keys
        required :value_type, :string, default: 'avro', enum: DESERIALIZERS.keys
        optional :client_id, :string, default: -> { Broker::Mixin.random_name :client_id }
        optional :group_id, :string, default: -> { Broker::Mixin.random_name :consumer, :group }
        optional :max_poll_records, :integer, default: MAX_POLL_DEFAULT
        optional :enable_auto_commit, :boolean, default: ENABLE_AUTO_COMMIT
        optional :auto_commit_interval_ms, :integer, default: AUTO_COMMIT_INTERVAL_MS
        optional :session_timeout_ms, :integer, default: SESSION_TIMEOUT_MS
        optional :auto_offset_reset, :string, default: OFFSET_RESETS.first, enum: OFFSET_RESETS
        optional :enable_idempotence, :boolean, default: true

        def to_hash
          super.except('topics').tap do |hsh|
            hsh['key_deserializer'] = deserializer_for hsh, 'key_type', 'string'
            hsh['value_deserializer'] = deserializer_for hsh, 'value_type', 'avro'
          end
        end

        def to_properties(opts = {})
          Broker::Mixin.java_props to_hash.update(opts)
        end

        private

        def deserializer_for(hsh, key, default)
          DESERIALIZERS.fetch(hsh.delete(key), default).java_class.name
        end
      end
    end
  end
end
