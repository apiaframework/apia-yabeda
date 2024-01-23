# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "apia/yabeda/version"

Gem::Specification.new do |spec|
  spec.name          = "apia-yabeda"
  spec.version       = Apia::Yabeda::VERSION
  spec.authors       = ["Paul Sturgess"]

  spec.summary       = "Apia Yabeda integration"
  spec.homepage      = "https://github.com/krystal/apia-yabeda"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/krystal/apia-yabeda"
  spec.metadata["changelog_uri"] = "https://github.com/krystal/apia-yabeda/changelog.md"

  spec.metadata["rubygems_mfa_required"] = "true" # (enabling MFA means we cannot auto publish via the CI)

  spec.files = Dir[File.join("lib", "**", "*.rb")] +
               Dir["{*.gemspec,Gemfile,Rakefile,README.*,LICENSE*}"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(/^exe\//) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 6"
  spec.add_dependency "yabeda", ">= 0.12"
  spec.add_dependency "yabeda-rails", ">= 0.9.0"
end
