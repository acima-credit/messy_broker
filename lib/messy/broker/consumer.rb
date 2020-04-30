# frozen_string_literal: true

require_relative 'consumer/constants'
require_relative 'consumer/consumer_options'

module Messy
  module Broker
    class Consumer
      include Mixin

      class << self
        # @return [Messy::Broker::Consumer]
        # @param [Hash{String->Object}] options
        def build(options = {})
          new options
        end

        # @param [Hash{String->Object}] options
        # @return [Array<Messy::Broker::Record>, Messy::Broker::Error]
        def poll(options = {})
          instance = build options.delete(:broker_options) || {}
          timeout = options.fetch(:timeout, POLL_TIMEOUT_MS).to_i
          results = instance.poll timeout
          instance.close
          results
        rescue Exception => e
          Error.new e
        end
      end

      attr_reader :started, :topics, :count

      def initialize(consumer_options = {})
        @options = ConsumerOptions.new consumer_options
        raise "invalid options: #{@options.errors.full_messages.join(', ')}" unless @options.valid?

        @lock = Concurrent::ReadWriteLock.new
        @started = false
        @props = @options.to_properties
        @topics = []
        @count = 0

        subscribe @options.topics
        at_exit { close }
      end

      def broker
        return @broker if @broker

        @lock.with_write_lock do
          @broker = CONSUMER_CLASS.new @props
          @started = true
        end
      end

      def subscribe(*new_topics)
        broker unless started

        @lock.with_write_lock do
          new_topics.flatten.map(&:to_s).each do |topic|
            unless topics.include?(topic)
              broker.subscribe java.util.Arrays.asList(topic)
              topics << topic
            end
          end
        end
      end

      # @param [Integer] timeout
      # @return [Array<Record>] list of messages returned
      def poll(timeout = 1_000)
        raise 'Must subscribe to at least one topic' if topics.empty?

        broker unless started

        @lock.with_write_lock do
          result = broker.poll timeout
          return [] if result.empty?

          broker.commit_async
          result.map do |x|
            @count += 1
            Record.from x
          end
        end
      end

      def close
        return false unless started

        @lock.with_write_lock do
          broker.close CLOSE_TIMEOUT_MS, TIME_UNIT::MILLISECONDS
          @broker = nil
          @started = false
          true
        end
      end
    end

    def self.build_consumer(*args, &blk)
      Consumer.build(*args, &blk)
    end

    def self.poll(*args, &blk)
      Consumer.poll(*args, &blk)
    end
  end
end
