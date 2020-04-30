# frozen_string_literal: true

require_relative 'producer/constants'
require_relative 'producer/ruby_callback'
require_relative 'producer/producer_options'
require_relative 'producer/record_header_options'
require_relative 'producer/record_options'
require_relative 'producer/record_builder'

module Messy
  module Broker
    class Producer
      class << self
        def build(options = {})
          new options
        end

        def send_message(value, options = {}, &blk)
          broker_opts = options.delete(:broker_options) || {}
          instance    = build broker_opts
          result, error = instance.send_message(value, options, &blk)
          instance.close
          [result, error]
        end

        def send_messages(values, options = {}, &blk)
          broker_opts = options.delete(:broker_options) || {}
          instance    = build broker_opts
          results     = values.map do |value|
            if value.is_a?(Array)
              val  = value[0]
              opts = options.deep_merge(value[1])
            else
              val  = value
              opts = options.dup
            end
            instance.send_message(val, opts, &blk)
          end
          instance.close
          results
        end
      end

      attr_reader :props, :started

      def initialize(producer_options = {})
        @options = ProducerOptions.new producer_options
        raise "invalid options: #{@options.errors.full_messages.join(', ')}" unless @options.valid?

        @lock = Concurrent::ReadWriteLock.new
        @started = false
        @props = @options.to_properties
        at_exit { close }
      end

      def broker
        return @broker if @broker

        @lock.with_write_lock do
          @broker = PRODUCER_CLASS.new @props
          @send_meth = @broker.java_method :send, [PRODUCER_RECORD_CLASS]
          @send_cb_meth = @broker.java_method :send, [PRODUCER_RECORD_CLASS, Callback.java_class]
          @started = true
        end

        @broker
      end

      def send_message(value, message_options, &block)
        message_options = RecordOptions.new message_options
        raise "invalid options: #{message_options.errors.full_messages.join(', ')}" unless message_options.valid?

        broker unless started

        record, error = RecordBuilder.build value, message_options, @options.value_type
        return error unless error.nil?

        res = @lock.with_write_lock do
          if block
            @send_cb_meth.call record, RubyCallback.new(block)
          else
            result = @send_meth.call record
            result.is_a?(FUTURE_RECORD_CLASS) ? Record::Metadata.from(result.get) : result
          end
        end
        [res, nil]
      rescue Exception => e
        [nil, Error.new(e)]
      end

      def close
        return false unless started

        @lock.with_write_lock do
          broker.close CLOSE_TIMEOUT_MS, TIME_UNIT::MILLISECONDS
          @broker       = nil
          @send_meth    = nil
          @send_cb_meth = nil
          @started      = false
          true
        end
      end
    end

    def self.build_producer(*args, &blk)
      Producer.build(*args, &blk)
    end

    def self.send_message(*args, &blk)
      Producer.send_message(*args, &blk)
    end

    def self.send_messages(*args, &blk)
      Producer.send_messages(*args, &blk)
    end
  end
end
