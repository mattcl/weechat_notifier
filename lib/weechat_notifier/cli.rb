require 'thor'
require 'yaml'

require 'weechat_notifier/client'

module WeechatNotifier
  class CLI < Thor
    include Thor::Actions

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
      unless File.exists?(options[:config])
        error 'config file does not exist'
        exit 1
      end

      conf = YAML.load_file(options[:config])
      client = Client.new(conf)

      say 'connection established'
      client.start
    end

    desc 'init', 'generate a config file'
    def init
      template('templates/weechat_notifier.yml.erb', File.join(ENV['HOME'], '.weechat_notifier.yml'))
    end
  end
end
