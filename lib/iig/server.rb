require 'net/irc'
require 'slop'

module InterestIrcGateway
  class Server < Net::IRC::Server
    def initialize(opts = nil)
      opts ||= parse_options
      super(opts[:server], opts[:port], InterestIrcGateway::Session, opts)
    end

    def parse_options
      opts = Slop.parse(help: true) do
        banner 'Usage: iig [options]'
        on :p, :port,    'Port number to listen (default: 16704)',                 argument: :optional, as: :integer, default: 16704
        on :s, :server,  'Host name or IP address to listen (default: localhost)', argument: :optional, as: :string,  default: :localhost
        on :w, :wait,    'Wait SECONDS between retrievals (default: 3600)',        argument: :optional, as: :integer, default: 3600
        on :l, :log,     'Log file (default: STDOUT)',                             argument: :optional, as: :string,  default: nil
        on :v, :version, 'Print the version' do
          puts InterestIrcGateway::VERSION
          exit
        end
      end

      exit if opts.present?(:help)

      logger = Logger.new(opts[:log] || STDOUT, 'daily')
      logger.level = Logger::DEBUG

      opts.to_hash.merge(logger: logger)
    end
  end
end
