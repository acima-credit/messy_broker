# frozen_string_literal: true

module Messy
  module Broker
    class Error < RuntimeError
      attr_reader :class_name

      def initialize(exception, message = nil)
        message ||= exception.message if exception.respond_to? :message
        super message

        @class_name = exception.class.name
        set_backtrace exception.backtrace
      end

      def to_hash
        { class_name: class_name, message: message }
      end

      def as_json(*)
        to_hash
      end
    end

    class RestError < Error
      attr_reader :status
      attr_reader :error_code

      def initialize(exception, message = exception.message)
        super exception, message

        @status = exception.status if exception.respond_to?(:status)
        @error_code = exception.error_code if exception.respond_to?(:error_code)
      end

      def to_hash
        super.update status: status, error_code: error_code
      end
    end
  end
end
