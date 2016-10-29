# frozen_string_literal: true
module OFX
  class Document
    class StatementTransaction < BankMessageSet
      def initialize(options = {})
        super
      end

      def trnuid
        @id
      end
    
      def statement_request
        StatementRequest.new(
          name: :stmtrq,
          routing: @routing,
          account: @account,
          start: @start,
          end: @end
        )
      end
    end
  end
end
