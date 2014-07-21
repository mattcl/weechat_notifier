require 'yaml'

module WeechatNotifier
  class Message
    attr_reader :highlight
    attr_reader :type
    attr_reader :channel
    attr_reader :server
    attr_reader :body
    attr_reader :from
    attr_reader :raw

    def initialize(raw_body)
      parsed_body = YAML.load(raw_body)

      @highlight = parsed_body[:highlight]
      @type      = parsed_body[:type]
      @channel   = parsed_body[:channel]
      @server    = parsed_body[:server]
      @body      = parsed_body[:message]
      @from      = extract_sender(parsed_body)
      @raw       = parsed_body
    end

    def extract_sender(parsed_body)
      match = parsed_body[:tags].map { |t| t.match(/^nick_(.*)$/) }.compact.first
      if match
        return match[1]
      end
    end
  end
end
