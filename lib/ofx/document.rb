# frozen_string_literal: true

module OFX
  class Document < Aggregate
    attr_reader :uri

    def initialize(options = {})
      @user = options[:user] || ENV['OFX_USER']
      @password = options[:password] || ENV['OFX_PASSWORD']
      @uri = options[:uri] || ENV['OFX_URI']
      @fi_org = options[:fi_org] || ENV['OFX_FI_ORG']
      @fi_fid = options[:fi_fid] || ENV['OFX_FI_FID']
      @routing = options[:routing] || ENV['OFX_ROUTING']
      @account = options[:account] || ENV['OFX_ACCOUNT']
      @app_id = options[:app_id] || ENV['OFX_APP_ID']
      @app_ver = options[:app_ver] || ENV['OFX_APP_VER']
      @start = options[:start] || (Date.today - 30)
      @end = options[:end] || Date.today
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
      @user || (raise Errors::UserMissing)
    end
    
    def password
      @password || (raise Errors::PasswordMissing)
    end
    
    def fi_org
      @fi_org || (raise Errors::FiOrgMissing)
    end
    
    def fi_fid
      @fi_fid || (raise Errors::FiFidMissing)
    end
    
    def routing
      @routing || (raise Errors::RoutingMissing)
    end
    
    def account
      @account || (raise Errors::AccountMissing)
    end
    
    def app_id
      @app_id || (raise Errors::AppIdMissing)
    end
    
    def app_ver
      @app_ver || (raise Errors::AppVerMissing)
    end
    
    def uri
      @uri || (raise Errors::URIMissing)
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

