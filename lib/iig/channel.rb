# encoding: utf-8

require 'hatena/bookmark'
require 'iig/channel/interest'

module InterestIrcGateway
  class Channel
    class << self
      def get(name)
        const_get(channel_name_classify(name))
      end

      def channel_name_classify(name)
        name.gsub('#', '').capitalize
      end
    end

    def initialize(options = {})
      @wait = options.fetch(:wait, 3600)
      @username = options.fetch(:username)

      @hatebu = Hatena::Bookmark.new(options).login

      @notified_entries = []
      @channel_members  = []
    end

    def stop
      puts "#{self.class} stop..."
      @stream_thread.kill rescue nil
    end

    def members
      @channel_members
    end

    def add_members(members)
      (members - @channel_members).each do |nick|
        @channel_members << nick
      end
    end

    def stream(&block)
      @steam_thread = Thread.start do
        loop do
          begin
            monitoring(&block)
            sleep @wait
          rescue Exception => e
            puts e.inspect
            e.backtrace.each { |l| puts l }
            sleep 300 # Retry after 300 seconds.
          end
        end
      end
    end
  end
end
