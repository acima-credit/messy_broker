# frozen_string_literal: true

module Messy
  module Broker
    class Consumer
      class ConsumerOptions < FieldStruct.flexible
        extras :add

        optional :key_type, :string, default: 'string', enum: DESERIALIZERS.keys
        optional :value_type, :string, default: 'avro', enum: DESERIALIZERS.keys

        required :topics, :array, of: :string

        optional :bootstrap_servers, :string, default: -> { Broker.bootstrap_servers }
        optional :client_id, :string, default: -> { Broker::Mixin.random_name :client_id }
        optional :group_id, :string, default: -> { Broker::Mixin.random_name :consumer, :group }
        optional :max_poll_records, :integer, default: MAX_POLL_DEFAULT
        optional :enable_auto_commit, :boolean, default: ENABLE_AUTO_COMMIT
        optional :auto_commit_interval_ms, :integer, default: AUTO_COMMIT_INTERVAL_MS
        optional :session_timeout_ms, :integer, default: SESSION_TIMEOUT_MS
        optional :auto_offset_reset, :string, default: OFFSET_RESETS.first, enum: OFFSET_RESETS
        optional :schema_registry_url, :string, default: -> { Broker.schema_registry_url }
        optional :enable_idempotence, :boolean, default: true

        def to_hash
          super.except('topics').tap do |hsh|
            hsh['key_deserializer'] = DESERIALIZERS.fetch hsh.delete('key_type'), DEFAULT_DESERIALIZER
            hsh['value_deserializer'] = DESERIALIZERS.fetch hsh.delete('value_type'), DEFAULT_DESERIALIZER
          end
        end

        def to_properties(opts = {})
          Broker::Mixin.java_props to_hash.update(opts)
        end
      end
    end
  end
end
