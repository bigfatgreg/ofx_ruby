# frozen_string_literal: true
module OFX
  class Document
    class BankMessageSet < Document
      def initialize(options = {})
        @routing = options[:routing]
        @account = options[:account]
        @start = options[:start]
        @end = options[:end]
        @id = options[:id]
        super
      end
    
      def statement_request
        StatementTransaction.new(
          name: :stmttrnrq,
          routing: @routing,
          account: @account,
          start: @start,
          end: @end,
          id: trnuid
        )
      end

      protected

      def trnuid
        @id
      end

    end
  end
end
