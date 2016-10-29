# frozen_string_literal: true
module OFX
  class HTTP
    attr_reader :uri, :body

    def initialize(options = {})
      @uri = options[:uri] || ENV['OFX_URI']
    end

    def uri
      @uri || (raise Errors::URIMissing)
    end

    def headers
      {
        'Content-Type': 'application/x-ofx',
        'Accept': '*/*, application/x-ofx'
      }
    end

    def raw_headers
      headers.inject('') do |result, (key, value)|
        result.dup << "#{key}: #{value}\n"
      end.strip
    end
  end
end
