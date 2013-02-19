$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'bundler/setup'

require 'vcr'
require 'minitest/unit'
require 'minitest/autorun'

require 'iig'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
