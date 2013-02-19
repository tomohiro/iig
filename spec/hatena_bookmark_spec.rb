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
        interests = @hatebu.interest(@username)
      end
    end
  end

  describe 'when access to the follow page' do
    it 'should get following users' do
      VCR.use_cassette('following') do
        following = @hatebu.following(@username)
      end
    end
  end

  describe 'when access to the favorite page' do
    it 'should get following users favorite entries' do
      VCR.use_cassette('favorite') do
        favorites = @hatebu.favorite(@username)
      end
    end
  end
end
