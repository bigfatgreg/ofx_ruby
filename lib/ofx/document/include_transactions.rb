# frozen_string_literal: true
module OFX
  class Document
    class IncludeTransactions < StatementRequest
      def initialize(options = {})
        @tag = :inctran
        @include = options[:include].nil? ? true : false
        super
      end

      def include
        include? ? 'Y' : 'N'
      end

      def dtstart
        date(@start || Date.today - 30)
      end

      def dtend
        date(@end || Date.today)
      end

      protected

      def include?
        @include
      end

      def date(date)
        date.strftime('%Y%m%d%H%M%S')
      end

      def order
        %w{ dtstart dtend include }
      end
    end
  end
end
