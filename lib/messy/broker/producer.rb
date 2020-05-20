# frozen_string_literal: true

require_relative 'producer/constants'
require_relative 'producer/ruby_callback'
require_relative 'producer/producer_options'
require_relative 'producer/record_header_options'
require_relative 'producer/record_options'
require_relative 'producer/value_builder'
require_relative 'producer/record_builder'

module Messy
  module Broker
    class Producer
      class << self
        def build(options = {})
          new options
        end

        # @param [Hash] value
        # @param [Hash] options
        # @param [Proc] blk
        def send_message(value, options = {}, &blk)
          broker_opts = options.delete(:broker_options) || {}
          instance = build broker_opts
          result = instance.send_message(value, options, &blk)
          instance.close
          result
        rescue Exception => e
          Error.new(e)
        end

        # @param [Array<Hash>] values
        # @param [Hash] options
        # @param [Proc] blk
        def send_messages(values, options = {}, &blk)
          broker_opts = options.delete(:broker_options) || {}
          instance = build broker_opts
          result = instance.send_messages(values, options, &blk)
          instance.close
          result
        rescue Exception => e
          Error.new(e)
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
          @broker = KafkaProducer.new @props
          @send_meth = @broker.java_method :send, [ProducerRecord]
          @send_cb_meth = @broker.java_method :send, [ProducerRecord, Callback.java_class]
          @started = true
        end

        @broker
      end

      def send_message(value, message_options = {}, &block)
        message_options = RecordOptions.new message_options.update(encode_format: @options.value_type)
        raise "invalid options: #{message_options.errors.full_messages.join(', ')}" unless message_options.valid?

        broker unless started

        record = RecordBuilder.build value, message_options
        return record if record.is_a?(Error)

        @lock.with_write_lock do
          if block
            @send_cb_meth.call record, RubyCallback.new(block)
          else
            result = @send_meth.call record
            result = Record::Metadata.from(result.get) if result.is_a?(FutureRecordMetadata)
            result
          end
        end
      rescue Exception => e
        Error.new(e)
      end

      def send_messages(values, options = {}, &blk)
        values.map do |value|
          if value.is_a?(Array)
            val = value[0]
            opts = options.dup.deep_merge value[1]
          else
            val = value
            opts = options.dup
          end
          send_message val, opts, &blk
        end
      end

      def close
        return false unless started

        @lock.with_write_lock do
          broker.close CLOSE_TIMEOUT_MS, TimeUnit::MILLISECONDS
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
