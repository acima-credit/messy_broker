# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      class RecordOptions < FieldStruct.flexible
        extras :ignore

        required :topic, :string
        optional :key, :string
        optional :partition, :integer
        optional :timestamp, :time
        optional :schema, :string
        optional :headers, RecordHeaderOptions, default: -> { {} }

        def schema=(value)
          if value.is_a?(String)
            @attributes.write_from_user 'schema', value
          elsif value.respond_to?(:to_json)
            @attributes.write_from_user 'schema', value.to_json
          else
            raise "Invalid value type [#{value.class.name}]"
          end
        end

        def headers=(value)
          @attributes.write_from_user 'headers', HashWithIndifferentAccess.new(value)
        end

        def has?(*fields)
          fields.all? { |x| attributes[x.to_s].present? }
        end
      end
    end
  end
end
