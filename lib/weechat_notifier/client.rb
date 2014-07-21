require 'bunny'
require 'libnotify'
require 'yaml'

require 'weechat_notifier/config'
require 'weechat_notifier/message'
require 'weechat_notifier/notifier'

module WeechatNotifier
  class Client
    attr_reader :exchange
    attr_reader :connection
    attr_reader :channel
    attr_reader :queue

    def initialize(config)
      @connection = Bunny.new(
        host: Config.data['host'],
        user: Config.data['user'],
        pass: Config.data['pass'],
        vhost: Config.data['vhost']
      )
      connection.start
      @channel = connection.create_channel
      @exchange = channel.fanout(Config.data['exchange'])
      @queue = connection.queue('', exclusive: true)
      queue.bind(exchange)
    end

    def start
      begin
        queue.subscribe(block: true) do |info, prop, raw_body|
          msg = Message.new(raw_body)
          Notifier.display(msg)
        end
      rescue Interrupt => _
        disconnect
      end
    end

    def disconnect
      channel.close
      connection.close
    end
  end
end
