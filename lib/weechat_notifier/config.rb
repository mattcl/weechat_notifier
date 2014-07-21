module WeechatNotifier
  module Config
    def self.data
      @data || {}
    end

    def self.set(data)
      @data = data
    end
  end
end
