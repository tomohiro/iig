# encoding: utf-8

require 'net/irc'
require 'hatena/bookmark'

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
      @hatebu = Hatena::Bookmark.new
      @bookmarks = []
      @users = []
    end

    def main_channel
      '#interest'
    end

    def on_user(message)
      super
      @hatebu.login(@real, @pass)

      post(@nick, JOIN, main_channel)

      Thread.start do
        loop do
          @log.info('monitoring bookmarks...')
          monitoring(main_channel)
          @log.info('sleep 300 seconds')
          sleep 300
        end
      end
    rescue => e
      @log.error(e.to_s)
    end

    def on_disconnected
      Thread.list.each do |thread|
        thread.kill
      end
    end

    private
      def monitoring(channel)
        @hatebu.interests(@real).each do |interest, entries|
          unless @users.include?(interest)
            post(interest, JOIN, channel)
            @users << interest
          end

          entries.each do |entry|
            url = entry[:url]
            next if @bookmarks.include?(url)

            privmsg(interest, channel, "#{entry[:title]} #{url} (#{entry[:users]})")
            @bookmarks << url
          end
        end
      rescue Exception => e
        @log.error(e.inspect)
        e.backtrace.each { |l| @log.error "\t#{l}" }
        sleep 300
      end

      def privmsg(nick, channel, message)
        post(nick, PRIVMSG, channel, message)
      end
  end
end
