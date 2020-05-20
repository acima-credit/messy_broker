# frozen_string_literal: true

module Messy
  module Broker
    module Schemas
      class SchemaMetadata < FieldStruct.flexible
        def self.from(original)
          new id: original.id,
              version: original.version,
              schema_type: original.schema_type,
              schema: original.schema,
              references: original.references.map { |x| SchemaReference.from x }
        end

        required :id, :integer
        required :version, :integer
        optional :schema_type, :string
        required :schema, :string
        optional :references, :array, of: SchemaReference
      end
    end
  end
end
