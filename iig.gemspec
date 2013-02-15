# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iig/version'

Gem::Specification.new do |gem|
  gem.name          = 'iig'
  gem.version       = InterestIrcGateway::VERSION
  gem.authors       = ['Tomohiro TAIRA']
  gem.email         = ['tomohiro.t@gmail.com']
  gem.description   = 'HatenaBookmark Interest IRC Gateway'
  gem.summary       = 'HatenaBookmark Interest IRC Gateway'
  gem.homepage      = 'https://github.com/Tomohiro/iig'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'net-irc'
  gem.add_runtime_dependency 'mechanize'
  gem.add_runtime_dependency 'slop'
end
