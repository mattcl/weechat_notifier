require 'bunny'
require 'libnotify'
require 'yaml'

require 'weechat_notifier/config'
require 'weechat_notifier/logging'
require 'weechat_notifier/message'
require 'weechat_notifier/notifier'
require 'weechat_notifier/xmobar'

module WeechatNotifier
  class Client
    include Logging

    DISCARD_TAGS = ['irc_nick_back', 'notify_none', 'irc_301']

    attr_reader :exchange
    attr_reader :connection
    attr_reader :channel
    attr_reader :queue

    def initialize
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
      ignored_senders = Config.data['ignored_senders'] || []
      begin
        queue.subscribe(block: true) do |info, prop, raw_body|
          msg = Message.new(raw_body)
          logger.debug "received: #{msg.raw.inspect}"
          if (msg.tags & DISCARD_TAGS).any? or ignored_senders.include?(msg.from)
            logger.debug 'discarding'
          elsif msg.disconnect?
            logger.debug "received disconnect"
            raise Interrupt
          else
            Notifier.display(msg) if show?

            if Config.data['xmobar']['enabled'] && !Xmobar.ignored_sender?(msg.from)
              Xmobar.write(msg)
            end
          end
        end
      rescue Interrupt => _
        disconnect
      end
    end

    def disconnect
      logger.info 'closing connection'
      channel.close
      connection.close
      if Config.data['xmobar']['enabled']
        logger.info 'closing file handle'
        Xmobar.close
      end
    end

    def show?
      check_command = Config.data['privacy_command']
      return true unless check_command

      res = IO.popen(check_command).readlines.last
      res.match(/show/i)
    end
  end
end
