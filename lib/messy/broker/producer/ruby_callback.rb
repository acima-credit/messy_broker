# frozen_string_literal: true

module Messy
  module Broker
    class Producer
      class RubyCallback
        include Callback

        def initialize(callback = nil, &block)
          @callback = block_given? ? block : callback
        end

        def onCompletion(metadata, exception)
          @callback.call(metadata, exception)
        end
      end
    end
  end
end
