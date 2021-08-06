# frozen_string_literal: true

require_relative "lib/gctime/version"

Gem::Specification.new do |spec|
  spec.name          = "gctime"
  spec.version       = GCTime::VERSION
  spec.authors       = ["Jean Boussier"]
  spec.email         = ["jean.boussier@gmail.com"]

  spec.summary       = "Exposes a monotonically increasing GC total_time metric."
  spec.homepage      = "https://github.com/Shopify/gctime"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]
end
