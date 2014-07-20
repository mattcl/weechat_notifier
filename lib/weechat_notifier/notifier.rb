require 'libnotify'

module WeechatNotifier
  class Notifier
    def self.display(msg)
      if msg.type == 'private'
        summary = "pm: #{msg.from}"
      else
        summary = "#{msg.from}:#{msg.channel}"
      end

      Libnotify.show(
        summary: summary,
        body: msg.body,
        timeout: 1.5
      )
    end
  end
end
