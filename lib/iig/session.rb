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

      @notified_entries = []
      @channel_members  = []
    end

    def main_channel
      '#interest'
    end

    def on_user(message)
      super
      @hatebu.login(@real, @pass)

      post(@nick, JOIN, main_channel)

      @monitoring_thread = Thread.start do
        loop do
          @log.info('monitoring bookmarks...')
          monitoring(main_channel)
          @log.info("sleep #{@opts.wait} seconds")
          sleep @opts.wait
        end
      end
    rescue => e
      @log.error(e.to_s)
    end

    def on_disconnected
      @monitoring_thread.kill rescue nil
    end

    private
      def monitoring(channel)
        interests = @hatebu.interests(@real)

        members = interests.keys
        join_to_channel(members, channel)

        interests.each do |nick, entries|
          entries.each do |entry|
            next if @notified_entries.include?(entry.url)
            @notified_entries << entry.url
            privmsg(nick, channel, "#{entry.title} #{entry.url} (#{entry.users})")
          end
        end
      rescue Exception => e
        @log.error(e.inspect)
        e.backtrace.each { |l| @log.error "\t#{l}" }
        sleep 300 # Retry after 300 seconds.
      end

      def privmsg(nick, channel, message)
        post(nick, PRIVMSG, channel, message)
      end

      def join_to_channel(members, channel)
        (members - @channel_members).each do |nick|
          post(nick, JOIN, channel)
          @channel_members << nick
        end
      end
  end
end
