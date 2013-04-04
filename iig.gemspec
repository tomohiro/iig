# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iig/version'

Gem::Specification.new do |spec|
  spec.name          = 'iig'
  spec.version       = InterestIrcGateway::VERSION
  spec.authors       = ['Tomohiro TAIRA']
  spec.email         = ['tomohiro.t@gmail.com']
  spec.description   = 'HatenaBookmark Interest IRC Gateway'
  spec.summary       = 'HatenaBookmark Interest IRC Gateway'
  spec.homepage      = 'https://github.com/Tomohiro/iig'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'net-irc'
  spec.add_runtime_dependency 'mechanize'
  spec.add_runtime_dependency 'slop'

  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
end
