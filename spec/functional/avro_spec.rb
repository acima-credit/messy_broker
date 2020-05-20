# frozen_string_literal: true

RSpec.describe Messy::Broker, :functional do
  context 'AVRO messages' do
    let(:encode_format) { 'avro' }
    context 'send and receives' do
      context 'with full schema' do
        it 'works' do
          debug_label :setup
          debug_var :payloads, payloads
          debug_var :producer_opts, producer_opts

          # send few messages
          debug_label :sending
          debug_var :messages, messages
          debug_var :record_opts, record_opts
          sent = producer.send_messages messages, record_opts
          debug_var :sent, sent
          expect(sent).to be_a Array
          expect(sent.size).to eq qty
          debug_error sent.first
          expect(sent.map(&:class).uniq.sort).to eq [Messy::Broker::Record::Metadata]
          expect(sent.map(&:topic).uniq.sort).to eq [topic]

          # receive few messages
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
          consumer.close

          # send extra messages
          debug_label :sending_extra
          debug_var :extra_messages, extra_messages
          debug_var :extra_record_opts, extra_record_opts
          sent_extra = producer.send_messages extra_messages, extra_record_opts
          debug_var :sent_extra, sent_extra
          debug_error sent_extra.first
          expect(sent_extra).to be_a Array
          expect(sent_extra.size).to eq extra_qty
          expect(sent_extra.map(&:class).uniq.sort).to eq [Messy::Broker::Record::Metadata]
          expect(sent_extra.map(&:topic).uniq.sort).to eq [topic]

          # receive extra messages
          debug_label :receiving_extra
          received_extra = extra_consumer.poll
          debug_var :received_extra, received_extra
          expect(received_extra).to be_a Array
          expect(received_extra.size).to eq extra_qty
          debug_error received_extra.first
          expect(received_extra.map(&:class).uniq.sort).to eq [Messy::Broker::Record]
          expect(received_extra.map(&:topic).uniq.sort).to eq [topic]
          expect(received_extra.map(&:parsed_value)).to eq extra_payloads
          expect(received_extra.map(&:key)).to eq extra_payloads.map { |x| x['name'] }
          extra_consumer.close

          # closing
          debug_label :done
          producer.close
          consumer.close
        end
      end
    end
  end
end
