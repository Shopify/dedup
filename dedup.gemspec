# frozen_string_literal: true

require_relative 'lib/dedup/version'

Gem::Specification.new do |spec|
  spec.name          = "dedup"
  spec.version       = Dedup::VERSION
  spec.authors       = ["Jean Boussier"]
  spec.email         = ["jean.boussier@gmail.com"]

  spec.summary       = %q{Fast object deduplication}
  spec.description   = %q{If your app keeps lots of static data in memory, such as i18n data or large configurations, this can reduce memory retention.}
  spec.homepage      = "https://github.com/Shopify/dedup"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    Dir['{lib,ext}/**/*'] + %w(LICENSE.txt README.md)
  end

  spec.extensions = ['ext/dedup/extconf.rb']

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
