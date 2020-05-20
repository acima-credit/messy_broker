# frozen_string_literal: true

module Messy
  module Broker
    module Schemas
      class SubjectVersion < FieldStruct.flexible
        def self.from(original)
          new subject: original.subject,
              version: original.version
        end

        required :subject, :string
        required :version, :integer
      end
    end
  end
end
