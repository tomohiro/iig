#!/usr/bin/env ruby
# encoding: utf-8

require 'time'
require 'open-uri'
require 'net/irc'
require 'mechanize'

module InterestIrcGateway
  class Session < Net::IRC::Server::Session
    def server_name
      :InterestIrcGateway
    end

    def server_version
      InterestIrcGateway::VERSION
    end

    def initialize(*args)
      super
      @bookmarks = []
      @users = []
    end

    def main_channel
      '#interest'
    end

    def interest_uri
      'http://b.hatena.ne.jp/%s/interest'
    end

    def on_user(message)
      super
      post(@nick, JOIN, main_channel)
      start_monitoring(main_channel, interest_uri)
    end

    def on_disconnected
      Thread.list.each do |thread|
        thread.kill
      end
    end

    private
      def start_monitoring(channel, uri)
        @agent = login_hatena

        Thread.start do
          loop do
            begin
              @log.info("#{channel} monitoring bookmarks...")

              extract_bookmarks(uri % @real) do |nick, title, url, users|
                unless @users.include?(nick)
                  post(nick, JOIN, channel)
                  @users << nick
                end

                next if @bookmarks.include?(url)
                privmsg(nick, channel, "#{title} #{url} (#{users})")
                @bookmarks << url
              end

              @log.info("#{channel} sleep 300 seconds")
              sleep 300
            rescue Exception => e
              @log.error(e.inspect)
              e.backtrace.each { |l| @log.error "\t#{l}" }
              sleep 300
            end
          end
        end
      end

      def login_hatena
        agent = Mechanize.new
        agent.user_agent_alias = 'Windows IE 7'

        if File.exists?('./cookie.yaml')
          agent.cookie_jar.load('./cookie.yaml')
          return agent
        end

        agent.get('https://www.hatena.ne.jp/login') do |page|
          response = page.form_with(action: '/login') do |form|
            form.field_with(name: 'name').value = @real
            form.field_with(name: 'password').value = @pass
          end.click_button

          if response.body.include?('The Hatena ID or password you entered does not match our records.')
            @log.error('Error: failed to loign.')
          end
        end

        agent.cookie_jar.save_as('./cookie.yaml')
        agent
      rescue => e
        @log.error(e)
        @log.info('Retry after 30 seconds...')
        sleep 30
        retry
      end

      def extract_bookmarks(uri, &block)
        @agent.get(uri) do |page|
          page.search('div.interest-sub-unit').each do |interest|
            nick = interest.at('h2/a').text
            interest.search('ul.sub-entry-list/li').each do |entry|
              link  = entry.at('h3/a')
              users = entry.at('span.users').text
              yield nick, link.attributes['title'].text, link.attributes['href'].text, users
            end
          end
        end
      end

      def privmsg(nick, channel, message)
        post(nick, PRIVMSG, channel, message)
      end
  end
end
