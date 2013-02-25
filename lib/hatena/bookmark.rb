# encoding: utf-8

require 'ostruct'
require 'open-uri'
require 'mechanize'

module Hatena
  class Bookmark
    attr_accessor :cookie_file_path

    def initialize(options = {})
      @agent = Mechanize.new
      @cookie_file_path = File.expand_path('./tmp/cookie.yaml')

      @username = options.fetch(:username)
      @password = options.fetch(:password)
    end

    def login
      return load_cookie(@agent) if cookie_exists?

      @agent.get('https://www.hatena.ne.jp/login') do |page|
        response = page.form_with(action: '/login') do |form|
          form.field_with(name: 'name').value = @username
          form.field_with(name: 'password').value = @password
        end.click_button

        if response.body.include?('The Hatena ID or password you entered does not match our records.')
          raise StandardError.new('Error: failed to loign.')
        end
      end

      save_cookie(@agent)
      @agent
    end

    private
      def cookie_exists?
        File.exists?(cookie_file_path)
      end

      def load_cookie(agent)
        agent.cookie_jar.load(cookie_file_path)
        agent
      end

      def save_cookie(agent)
        agent.cookie_jar.save_as(cookie_file_path)
      end
  end
end
