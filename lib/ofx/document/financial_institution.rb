# frozen_string_literal: true
module OFX
  class Document
    class FinancialInstitution < SignonRequest
      @@tag = :fi

      def initialize(options = {})
        super
      end

      def org
        @fi_org
      end

      def fid
        @fi_fid
      end
    end
  end
end