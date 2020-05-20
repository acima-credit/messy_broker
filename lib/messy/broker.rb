# frozen_string_literal: true

require 'socket'
require 'field_struct'

require_relative 'broker/jars/messy_broker_jars'
require_relative 'broker/errors'
require_relative 'broker/schemas'
require_relative 'broker/mixin'
require_relative 'broker/record'
require_relative 'broker/producer'
require_relative 'broker/consumer'

module Messy
  module Broker
    module_function

    def bootstrap_servers
      @bootstrap_servers || ENV.fetch('BROKERS', 'localhost:9092')
    end

    def bootstrap_servers=(value)
      @bootstrap_servers = value.to_s
    end

    def schema_registry_url
      @schema_registry_url || ENV.fetch('SCHEMA_REGISTRY_URL', 'http://localhost:8081')
    end

    def schema_registry_url=(value)
      @schema_registry_url = value.to_s
    end
  end
end
