#!/usr/bin/env ruby
# frozen_string_literal: true

require 'tmpdir'
require 'yaml'
require 'bootsnap'
require 'benchmark/ips'
require 'bundler/setup'
require 'dedup'

Bootsnap.setup(
  cache_dir: Dir.mktmpdir,
  development_mode: false,
  compile_cache_yaml: true,
  autoload_paths_cache: false,
)

YAML_PATH = ARGV.fetch(0)

Benchmark.ips do |x|
  x.time = 30
  x.report('baseline') { YAML.load_file(YAML_PATH) }
  x.report('ruby') { Dedup::Ruby.deep_intern!(YAML.load_file(YAML_PATH)) }
  x.report('native') { Dedup::Native.deep_intern!(YAML.load_file(YAML_PATH)) }
  x.compare!
end