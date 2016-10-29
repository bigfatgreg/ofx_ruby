# frozen_string_literal: true
module OFX
  class Document
    class SignonMessageSet < Document
      def initialize(options = {})
        @user = options[:user]
        @password = options[:password]
        @time = options[:time]
        @fi_org = options[:fi_org]
        @fi_fid = options[:fi_fid]
        @app_id = options[:app_id]
        @app_ver = options[:app_ver]
        super
      end

      def sonrq
        SignonRequest.new(
          name: :sonrq,
          user: @user,
          password: @password,
          time: @time,
          fi_org: @fi_org,
          fi_fid: @fi_fid,
          app_id: @app_id,
          app_ver: @app_ver
        )
      end      
    end
  end
end
