# frozen_string_literal: true
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7'
  require "rake/extensiontask"

  Rake::ExtensionTask.new("dedup") do |ext|
    ext.ext_dir = 'ext/dedup'
    ext.lib_dir = "lib/dedup"
  end
else
  task :compile do
    # noop
  end

  task :clean do
    # noop
  end
end

task default: %i(compile test)
