# frozen_string_literal: true
module OFX
  class Document
    class SignonRequest < SignonMessageSet
      def initialize(options = {})
        super
      end

      def appver
        @app_ver
      end

      def appid
        @app_id
      end

      def language
        'ENG'
      end

      def fi
        FinancialInstitution.new(name: :fi, fi_org: @fi_org, fi_fid: @fi_fid)
      end

      def userpass
        @password
      end

      def userid
        @user
      end

      def dtclient
        @time
      end

      protected

      def order
        %w{ dtclient userid userpass language fi appid appver }
      end
    end
  end
end