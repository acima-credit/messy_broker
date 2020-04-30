# frozen_string_literal: true

module Messy
  module Broker
    class Error < RuntimeError
      attr_reader :class_name

      def initialize(exception, message = exception.message)
        super message

        @class_name = exception.class.name
        set_backtrace exception.backtrace
      end
    end
  end
end
