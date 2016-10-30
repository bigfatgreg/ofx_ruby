# frozen_string_literal: true
module OFX
  class Handler < Ox::Sax
    TRANSACTION_ATTRS = [:TRNTYPE, :DTPOSTED, :TRNAMT, :FITID, :NAME]
    BALANCE_ATTRS = [:BALAMT]
    ATTRS_MAP = { TRNTYPE: :as_s, DTPOSTED: :as_time, BALAMT: :as_f,
                  TRNAMT: :as_f, FITID: :as_s, NAME: :as_s }

    def initialize(parser)
      @parser = parser
    end                  

    def start_element(name)
      case name
      when :STMTTRN then @transaction = {}
      when :LEDGERBAL || :AVAILBAL then @balance = {}
      end
      @current = name
    end

    def value(value)
      case
      when TRANSACTION_ATTRS.include?(@current)
        @transaction[@current] = value.send(ATTRS_MAP[@current])
      when BALANCE_ATTRS.include?(@current)
        @balance[@current] = value.send(ATTRS_MAP[@current])
      end
    end

    def end_element(name)
      case name
      when :STMTTRN
        @parser.output[:transactions] = [] unless @parser.output[:transactions]
        @parser.output[:transactions].push(transaction)
      when :LEDGERBAL
        @parser.output[:balance] = @balance[:BALAMT]
      when :AVAILBAL
        @parser.output[:pending] = @balance[:BALAMT] - @parser.output[:balance]
      end
    end
    
    protected
    
    def transaction
      { type: @transaction[:TRNTYPE], posted: @transaction[:DTPOSTED],
        amount: @transaction[:TRNAMT], fitid: @transaction[:FITID],
        name: @transaction[:NAME] }
    end
  end
end