# encoding: utf-8

require 'spec_helper'
require 'hatena/bookmark'

describe Hatena::Bookmark do
  before do
    @username = 'Tomohiro'
    @hatebu = Hatena::Bookmark.new
  end

  describe 'when access to the interest page' do
    it 'should get interest entries' do
      VCR.use_cassette('interest') do
        interests = @hatebu.interests(@username)
      end
    end
  end
end
