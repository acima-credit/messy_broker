# frozen_string_literal: true

module Messy
  module Broker
    module Schemas
      class SchemaReference < FieldStruct.flexible
        def self.from(original)
          new name: original.name,
              subject: original.subject,
              version: original.version
        end

        required :name, :string
        required :subject, :string
        optional :version, :integer
      end
    end
  end
end
