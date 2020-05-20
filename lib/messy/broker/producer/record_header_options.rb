# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      class RecordHeaderOptions < FieldStruct.flexible
        extras :add

        ENCODINGS = %w[json avro].freeze

        optional :encode_format, :string, enum: ENCODINGS, default: ENCODINGS.first
        optional :app_name, :string
        optional :app_version, :string
        optional :schema_name, :string
        optional :schema_version, :string
        optional :schema_id, :integer

        def to_props
          to_hash.update(extras).each_with_object({}) do |(k, v), props|
            next if v.nil?

            add_props_entry props, k, v
          end
        end

        private

        def add_props_entry(hsh, k, v, prefix = nil)
          key = prefix ? "#{prefix}." : ''
          key += k.to_s.gsub('_', '.')
          if v.is_a?(String)
            hsh[key] = v
          elsif v.is_a?(Hash)
            v.each { |k2, v2| add_props_entry hsh, k2, v2, k }
          elsif v.respond_to?(:to_json)
            hsh[key] = v.to_json
          else
            hsh[key] = v.to_s
          end
        end
      end
    end
  end
end
