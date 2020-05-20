# frozen_string_literal: true

RSpec.describe Messy::Broker, :functional do
  context 'JSON messages' do
    let(:encode_format) { 'json' }
    context 'send and receives' do
      context 'with full schema' do
        it 'works' do
          debug_label :setup
          debug_var :payloads, payloads
          debug_var :producer_opts, producer_opts
          debug_var :no_schema_record_opts, no_schema_record_opts
          # send messages
          debug_label :sending
          sent = producer.send_messages messages, no_schema_record_opts
          debug_var :sent, sent
          debug_error sent.first
          expect(sent).to be_a Array
          expect(sent.size).to eq qty
          expect(sent.map(&:class).uniq.sort).to eq [Messy::Broker::Record::Metadata]
          expect(sent.map(&:topic).uniq.sort).to eq [topic]
          # receive messages
          debug_label :receiving
          received = consumer.poll
          debug_var :received, received
          debug_error received.first
          expect(received).to be_a Array
          expect(received.size).to eq qty
          expect(received.map(&:class).uniq.sort).to eq [Messy::Broker::Record]
          expect(received.map(&:topic).uniq.sort).to eq [topic]
          expect(received.map(&:parsed_value)).to eq payloads
          expect(received.map(&:key)).to eq payloads.map { |x| x['name'] }
          # closing
          debug_label :done
          producer.close
          consumer.close
        end
      end
    end
  end
end
