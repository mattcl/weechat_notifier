require 'thor'

module WeechatNotifier
  class CLI < Thor
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

      conf = YAML.load_file(options[:config]).symbolize_keys
      client = Client.new(conf)
      client.start
    end

    desc 'init', 'generate a config file'
    def init

    end
  end
end
