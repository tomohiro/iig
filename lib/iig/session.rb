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
        entries = @hatebu.send(channel.gsub('#', ''), @real)

        (entries.map(&:first).uniq - @channel_members).each do |nick|
          post(nick, JOIN, channel)
          @channel_members << nick
        end

        entries.each do |entry_info|
          nick, entry = entry_info[0], entry_info[1]
          url = entry.url
          next if @notified_entries.include?(url)

          privmsg(nick, channel, "#{entry.title} #{url} (#{entry.users})")
          @notified_entries << url
        end
      rescue Exception => e
        @log.error(e.inspect)
        e.backtrace.each { |l| @log.error "\t#{l}" }
        sleep 300 # Retry after 300 seconds.
      end

      def privmsg(nick, channel, message)
        post(nick, PRIVMSG, channel, message)
      end
  end
end
