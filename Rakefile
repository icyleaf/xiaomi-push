require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'dotenv/tasks'
require 'awesome_print'


RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :test => :dotenv do
  ap ENV
end
