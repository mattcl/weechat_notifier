module WeechatNotifier
  module Config
    DEFAULT = {
      'xmobar' => {}
    }

    def self.data
      @data || {}
    end

    def self.set(data)
      @data = DEFAULT.merge(data)
    end
  end
end
