# frozen_string_literal: true

require 'jars/installer'
require 'rspec/core/rake_task'
require 'pathname'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RAKE_ROOT = Pathname.new('.').dirname.expand_path

desc 'Vendor jars'
task :vendor_jars do
  # FileUtils.rm_rf RAKE_ROOT.join('lib', 'jars')
  # Jars::Installer.vendor_jars! 'lib/jars'
  # Rake::Task['rubocop:auto_correct'].invoke
  pattern = RAKE_ROOT.join 'lib', 'jars', '*.jar'
  dest = RAKE_ROOT.join 'lib', 'messy', 'broker', 'jars.rb'

  # Pull jars with maven
  sh 'mvn clean dependency:copy-dependencies'
  # rewrite jars loader
  File.open(dest, 'w') do |f|
    f.puts '# frozen_string_literal: true'
    f.puts ''
    f.puts 'path = Pathname.new(__FILE__).dirname'
    f.puts '$LOAD_PATH.unshift(path.to_s) unless $LOAD_PATH.include?(path.to_s)'
    f.puts ''
    Dir.glob(pattern).sort.each do |path|
      f.puts "require '#{path.split('/').last}'"
    end
  end
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |task|
    task.rspec_opts = ["-I#{RAKE_ROOT}", "-I#{RAKE_ROOT}/spec", '--color', '--format doc']
    task.rspec_opts << '--tag ~skip_ci' if ENV['CI'] == 'true'
    task.verbose = false
  end
  task default: :spec
rescue LoadError
  # No RSPEC for you!
end

begin
  require 'rubocop/rake_task'
  desc 'Runs rubocop with our custom settings'
  RuboCop::RakeTask.new(:rubocop) do |task|
    config = RAKE_ROOT.join('.rubocop.yml').to_s
    task.options = ['-D', '-c', config]
  end
rescue LoadError
  # Not loading rubocop tasks ...
end
