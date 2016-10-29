# frozen_string_literal: true
module OFX
  class Handler < Ox::Sax
    TRANSACTION_ATTRS = [:TRNTYPE, :DTPOSTED, :TRNAMT, :FITID, :NAME]
    ATTRS_MAP = { TRNTYPE: :as_s, DTPOSTED: :as_time,
                  TRNAMT: :as_f, FITID: :as_s, NAME: :as_s }

    def initialize(parser)
      @parser = parser
    end                  

    def start_element(name)
      @transaction = {} if name == :STMTTRN
      @current_node = name
    end

    def value(value)
      return unless TRANSACTION_ATTRS.include?(@current_node)
      @transaction[@current_node] = value.send(ATTRS_MAP[@current_node])
    end

    def end_element(name)
      return unless name == :STMTTRN
      @parser.output[:transactions] = [] if @parser.output[:transactions].nil?
      @parser.output[:transactions].push(
        type: @transaction[:TRNTYPE],
        posted: @transaction[:DTPOSTED],
        amount: @transaction[:TRNAMT],
        fitid: @transaction[:FITID],
        name: @transaction[:NAME]
      )
    end
  end
end