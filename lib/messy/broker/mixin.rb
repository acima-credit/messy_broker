# frozen_string_literal: true

module Messy
  module Broker
    module Mixin
      module_function

      PROPERTIES_CLASS = Java::JavaUtil::Properties # java.util.Properties
      ARRAYS_CLASS     = Java::JavaUtil::Arrays # java.util.Arrays

      def random_name(*extras)
        extras = extras.map(&:to_s).join('-')
        format '%s-%s-%s', extras, Socket.gethostname, SecureRandom.hex[0, 6]
      end

      def default_broker_options
        {
          bootstrap_servers: Broker.bootstrap_servers
        }
      end

      def broker_options(final_options, options = {})
        default_broker_options.update(options).update(final_options)
      end

      def java_props(properties)
        PROPERTIES_CLASS.new.tap do |java_properties|
          properties.each do |k, v|
            k = k.to_s.gsub '_', '.'
            v = v.to_s
            java_properties.setProperty k, v
          end
        end
      end
    end
  end
end
