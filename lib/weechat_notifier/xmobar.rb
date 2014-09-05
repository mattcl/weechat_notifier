require 'securerandom'

require 'weechat_notifier/config'

module WeechatNotifier
  class Xmobar
    def self.filename
      'xmobar-chats'
    end

    def self.path
      @path ||= File.join('/tmp', self.filename)
    end

    def self.file_handle
      @file ||= File.open(path, 'w+')
    end

    def self.write(msg)
      message = "<#{msg.from}> #{msg.body}"
      if message.length > 80
        message = message[0..79] + '...'
      end
      self.file_handle.puts message
    end

    def self.close
      self.file_handle.close
    end

    def self.ignored_sender?(sender)
      Config.data['xmobar']['ignored_senders'].include?(sender.downcase)
    end
  end
end
