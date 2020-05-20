# frozen_string_literal: true

require_relative 'schemas/constants'
require_relative 'schemas/schema_reference'
require_relative 'schemas/schema_metadata'
require_relative 'schemas/schema'
require_relative 'schemas/subject_version'
require_relative 'schemas/registry'

module Messy
  module Broker
    module Schemas
      def self.registry
        @registry ||= Registry.new
      end

      # @param [String] subject
      # @param [String] schema_str
      def register(subject, schema_str); end
    end
  end
end
