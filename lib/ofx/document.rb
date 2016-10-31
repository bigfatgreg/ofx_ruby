# frozen_string_literal: true

module OFX
  class Document < Aggregate
    attr_reader :uri

    def initialize(options = {})
      @start = options[:start] || (Date.today - 30)
      @end = options[:end] || Date.today
      @uri = options[:uri]
      @user = options[:user]
      @password = options[:password]
      @routing = options[:routing]
      @account = options[:account]
      @fi_org = options[:fi_org]
      @fi_fid = options[:fi_fid]
      @app_id = options[:app_id]
      @app_ver = options[:app_ver]
      super
    end
    
    def signon
      SignonMessageSet.new(
        name: :signonmsgsrqv1,
        time: Time.now.strftime('%Y%m%d%H%M%S'),
        user: user,
        password: password,
        fi_org: fi_org,
        fi_fid: fi_fid,
        app_id: app_id,
        app_ver: app_ver
      )
    end

    def bank
      BankMessageSet.new(
        name: :bankmsgsrqv1,
        routing: routing,
        account: account,
        id: trnuid,
        start: @start,
        end: @end
      )
    end

    protected

    def dtclient
      Time.now.strftime('%Y%m%d%H%M%S')
    end

    def trnuid
      Time.now.to_i.to_s
    end

    def user
      @user || ENV['OFX_USER'] || (raise Errors::UserMissing)
    end

    def password
      @password || ENV['OFX_PASSWORD'] || (raise Errors::PasswordMissing)
    end

    def fi_org
      @fi_org || ENV['OFX_FI_ORG'] || (raise Errors::FiOrgMissing)
    end

    def fi_fid
      @fi_fid || ENV['OFX_FI_FID'] || (raise Errors::FiFidMissing)
    end

    def routing
      @routing || ENV['OFX_ROUTING'] || (raise Errors::RoutingMissing)
    end

    def account
      @account || ENV['OFX_ACCOUNT'] || (raise Errors::AccountMissing)
    end

    def app_id
      @app_id || ENV['OFX_APP_ID'] || (raise Errors::AppIdMissing)
    end

    def app_ver
      @app_ver || ENV['OFX_APP_VER'] || (raise Errors::AppVerMissing)
    end

    def uri
      @uri || ENV['OFX_URI'] || (raise Errors::URIMissing)
    end

    def http
      @http ||= HTTP.new(uri: @uri)
    end

    def ofx_header
      {
        ofxheader: 100,
        data: 'OFXSGML',
        version: 103,
        security: 'NONE',
        encoding: 'UNICODE',
        charset: 1252,
        compression: 'NONE',
        oldfileuid: 'NONE',
        newfileuid: 'NONE'
      }.inject('') do |result, values|
        result.dup << "#{values[0].upcase}:#{values[1]}\n"
      end
    end

    def body
      [ofx_header, element_group].join
    end
  end
end

