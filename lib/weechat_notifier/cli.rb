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
    def start
      logger.level = Logger::DEBUG

      unless File.exists?(options[:config])
        logger.error 'config file does not exist'
        exit 1
      end

      Config.set(YAML.load_file(options[:config]))
      client = Client.new

      logger.info 'connection established'
      client.start
    end

    desc 'init', 'generate a config file'
    def init
      template('templates/weechat_notifier.yml.erb', File.join(ENV['HOME'], '.weechat_notifier.yml'))
    end
  end
end
