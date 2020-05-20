# frozen_string_literal: true

require_relative 'lib/messy/broker/version'

Gem::Specification.new do |spec|
  spec.name = 'messy_broker'
  spec.version = Messy::Broker::VERSION
  spec.authors = ['Adrian Esteban Madrid']
  spec.email = ['aemadrid@gmail.com']

  spec.summary = 'A Kafka client for the Messy platform'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/acima-credit/messy_broker'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.7')

  spec.platform = 'java'

  spec.metadata['homepage_uri'] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib/messy/broker/jars lib]

  spec.requirements << 'jar org.slf4j:slf4j-api, 1.8.0-beta4'
  spec.requirements << 'jar org.slf4j:slf4j-simple, 1.8.0-beta4'
  spec.requirements << 'jar org.apache.kafka:kafka-clients, 2.4.0'
  spec.requirements << 'jar org.apache.avro:avro, 1.9.2'
  spec.requirements << 'jar tech.allegro.schema.json2avro:converter, 0.2.9'
  spec.requirements << 'jar org.apache.kafka:kafka_2.12, 5.5.0-ccs'
  spec.requirements << 'jar io.confluent:kafka-avro-serializer, 5.5.0'
  # spec.requirements << 'jar io.confluent:kafka-schema-registry-client, 5.5.0'

  spec.add_runtime_dependency 'field_struct'
  spec.add_runtime_dependency 'jar-dependencies'

  spec.add_development_dependency 'field_struct_avro_schema'

  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'ruby-maven'
end
