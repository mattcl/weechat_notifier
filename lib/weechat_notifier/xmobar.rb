require 'securerandom'

require 'weechat_notifier/config'
require 'weechat_notifier/logging'

module WeechatNotifier
  class Xmobar
    include Logging

    def self.max_len
      @max_len ||= Config.data['xmobar']['max_len'].to_i
    end

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
      logger.debug "xmobar writing: #{msg.inspect}"
      message = "<#{msg.from}> #{msg.body}"
      if message.length > self.max_len
        message = message[0..(self.max_len - 1)] + '...'
      end
      self.file_handle.puts message
      self.file_handle.flush
    end

    def self.close
      self.file_handle.close
    end

    def self.ignored_sender?(sender)
      Config.data['xmobar']['ignored_senders'].include?(sender.downcase)
    end
  end
end
