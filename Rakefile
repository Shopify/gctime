# frozen_string_literal: true

require "rake/extensiontask"
require "bundler/gem_tasks"
require "rake/testtask"

gemspec = Gem::Specification.load("gctime.gemspec")
Rake::ExtensionTask.new do |ext|
  ext.name = 'gctime'
  ext.ext_dir = 'ext/gctime'
  ext.lib_dir = 'lib/gctime'
  ext.gem_spec = gemspec
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: %i(compile test)
