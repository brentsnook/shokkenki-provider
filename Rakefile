require 'rubygems'
require 'bundler'
require 'cucumber/rake/task'
require_relative 'lib/shokkenki/provider/version'

Bundler.setup
Bundler::GemHelper.install_tasks

require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc 'Push features to shokkenki project site for current version of the shokkenki provider'
task :relish do
  sh "relish push shokkenki/shokkenki-provider:#{Shokkenki::Provider::Version::STRING}"
end

task :default => [:spec]