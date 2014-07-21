require 'libnotify'

module WeechatNotifier
  class Notifier
    DEFAULT_DURATION = 2.5

    def self.display(msg)
      if msg.type == 'private'
        summary = "pm: #{msg.from}"
      else
        summary = "#{msg.from}:#{msg.channel}"
      end

      duration = Config.data['notice_duration'] || DEFAULT_DURATION

      Libnotify.show(
        summary: summary,
        body: msg.body,
        timeout: duration
      )
    end
  end
end
