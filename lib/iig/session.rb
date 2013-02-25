# encoding: utf-8

require 'net/irc'

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
      @channels = []
    end

    def on_user(message)
      super
      channel_streaming('#interest')
    end

    def on_disconnected
      @channels.each(&:stop)
    end

    private
      def channel_streaming(name)
        klass   = Channel.get(name)
        channel = klass.new(username: @real, password: @pass, wait: @opts.wait)

        join(@nick, name)
        channel.stream do |nick, activity|
          privmsg(nick, name, activity)
        end
        @channels << channel
      rescue => e
        @log.error(e.to_s)
      end

      def privmsg(nick, channel, message)
        post(nick, PRIVMSG, channel, message)
      end

      def join(nick, channel)
        post(nick, JOIN, channel)
      end
  end
end
