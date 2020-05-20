# frozen_string_literal: true

RSpec.describe Messy::Broker, :functional do
  context 'AVRO messages' do
    let(:app_name) { 'test_app' }
    let(:app_version) { 1 }
    let(:encode_format) { 'avro' }
    let(:instance_class) { FunctionalHelpers::Friend }
    let(:metadata) { instance_class.metadata }
    context 'send and receives' do
      let(:producer_opts) do
        {
          key_type: 'string',
          value_type: encode_format
        }
      end
      let(:producer) { Messy::Broker.build_producer producer_opts }
      let(:record_opts) do
        {
          topic: topic,
          schema: metadata.to_avro_json,
          headers: {
            encode_format: encode_format,
            app_name: app_name,
            app_version: app_version,
            schema_name: metadata.name,
            schema_version: metadata.version
          }
        }
      end
      let(:instances) { qty.times.map { build_friend } }
      let(:payloads) { instances.map(&:to_hash) }
      let(:messages) { payloads.map { |x| [x, key: x['name']] } }
      let(:cons_opts) do
        {
          max_poll_records: 1_000,
          auto_offset_reset: 'earliest',
          topics: [topic]
        }
      end
      let(:consumer) { Messy::Broker.build_consumer cons_opts }
      context 'with full schema' do
        let(:topic) { format 'friends-%s', SecureRandom.uuid[0, 5] }
        let(:qty) { 10 }
        it 'works' do
          puts ' [ setup ] '.center(90, '=')
          puts "> payloads | #{payloads.to_yaml}"
          puts "> producer_opts | #{producer_opts.to_yaml}"
          puts "> record_opts | #{record_opts.to_yaml}"
          # send messages
          puts ' [ sending ] '.center(90, '=')
          sent = producer.send_messages messages, record_opts
          puts "> sent | (#{sent.class.name}) #{sent.to_yaml}"
          expect(sent).to be_a Array
          expect(sent.size).to eq qty
          if (found = sent.first).is_a?(Messy::Broker::Error)
            puts "Exception: #{found.class.name} : #{found.message}:\n  #{found.backtrace.join("\n  ")}"
          end
          expect(sent.map(&:class).uniq.sort).to eq [Messy::Broker::Record::Metadata]
          expect(sent.map(&:topic).uniq.sort).to eq [topic]
          # receive messages
          puts ' [ receiving ] '.center(90, '=')
          received = consumer.poll
          puts "> received | (#{received.class.name}) #{received.to_yaml}"
          expect(received).to be_a Array
          expect(received.size).to eq qty
          if (found = received.first).is_a?(Messy::Broker::Error)
            puts "Exception: #{found.class.name} : #{found.message}:\n  #{found.backtrace.join("\n  ")}"
          end
          expect(received.map(&:class).uniq.sort).to eq [Messy::Broker::Record]
          expect(received.map(&:topic).uniq.sort).to eq [topic]
          expect(received.map(&:parsed_value)).to eq payloads
          expect(received.map(&:key)).to eq payloads.map { |x| x['name'] }
          # closing
          puts ' [ done ] '.center(90, '=')
          producer.close
          consumer.close
        end
      end
    end
  end
end
