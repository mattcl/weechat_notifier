require 'thor'
require 'yaml'
require 'logger'

require 'weechat_notifier/client'
require 'weechat_notifier/config'
require 'weechat_notifier/logging'

module WeechatNotifier
  class CLI < Thor
    include Thor::Actions
    include Logging

    def self.source_root
      File.dirname(__FILE__)
    end

    desc 'start', 'start the notifier'
    option :config,
      aliases: '-c',
      type: :string,
      default: File.join(ENV['HOME'], '.weechat_notifier.yml'),
      desc: 'path to the config file'
    option :log_level,
      aliases: '-l',
      type: :string,
      defaut: 'info',
      desc: 'the log level'
    option :xmobar,
      aliases: '-x',
      type: :boolean,
      desc: 'output to an xmobar-readable file'

    def start
      set_log_level(options[:log_level])

      unless File.exists?(options[:config])
        logger.error 'config file does not exist'
        exit 1
      end

      Config.set(YAML.load_file(options[:config]))
      Config.data['xmobar']['enabled'] = options[:xmobar]

      client = Client.new

      logger.info 'connection established'
      if Config.data['xmobar']['enabled']
        logger.info 'will write to xmobar tmp file'
        client.start
      end
    end

    desc 'init', 'generate a config file'
    def init
      template('templates/weechat_notifier.yml.erb', File.join(ENV['HOME'], '.weechat_notifier.yml'))
    end

    protected

    def set_log_level(level)
      case level.to_s.downcase
      when 'error'
        logger.level = Logger::ERROR
      when 'warn'
        logger.level = Logger::WARN
      when 'debug'
        logger.level = Logger::DEBUG
      else
        logger.level = Logger::INFO
      end
    end
  end
end
