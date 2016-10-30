# frozen_string_literal: true
module OFX
  class Parser
    attr_reader :body
    attr_accessor :output
    
    def initialize(body, options = {})
      @body = body
      @output = {}
      dump
    end

    def ofx_version
      @body[/VERSION:([0-9]{3})/, 1].to_i
    end

    def transactions
      @output[:transactions]
    end

    def balance
      @output[:balance].round(2)
    end

    def pending
      @output[:pending].round(2)
    end

    protected

    def dump
      @dump ||= Ox.sax_parse(Handler.new(self), @body)
    end
  end
end