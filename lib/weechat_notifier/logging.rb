require 'logger'

module WeechatNotifier
  module Logging
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def logger
      Logging.logger
    end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def logger
        Logging.logger
      end
    end
  end
end
