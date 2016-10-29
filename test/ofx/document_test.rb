# frozen_string_literal: true
require 'test_helper'

class OFX::DocumentTest
  describe OFX::Document do
    before do
      @user = 'ofxuser'
      @password = 'password'
      @routing = 930291303
      @account = 48320949
      @inst = { org: 'fiorg', id: '32' }
      @app = { id: 'QBW', ver: '32' }
      @doc = OFX::Document.new(
        name: :ofx,
        user: @user,
        password: @password,
        fi_org: @inst[:org],
        fi_fid: @inst[:id],
        routing: @routing,
        account: @account,
        app_id: @app[:id],
        app_ver: @app[:ver],
        start: Date.new(2015, 12, 28),
        end: Date.new(2016, 1, 28)
      )
    end
    
    after do
      Dotenv.load
    end

    it 'inherits from the Aggregate class' do
      assert_equal OFX::Aggregate, @doc.class.superclass
    end

    it 'has a label associated with the class' do
      assert_equal :ofx, @doc.send(:tag)
    end

    it 'has an ofx user' do
      assert_equal @user, @doc.send(:user)
    end

    it 'raises an error if a user is not specified' do
      assert_raises OFX::Errors::UserMissing do
        ENV['OFX_USER'] = nil
        @doc = OFX::Document.new
        @doc.send(:user)
      end
    end

    it 'has an ofx password' do
      assert_equal @password, @doc.send(:password)
    end

    it 'raises an error if a password is not specified' do
      assert_raises OFX::Errors::PasswordMissing do
        ENV['OFX_PASSWORD'] = nil
        @doc = OFX::Document.new
        @doc.send(:password)
      end
    end

    it 'has an ofx fi_org' do
    	assert_equal @inst[:org], @doc.send(:fi_org)
    end

    it 'raises an error if fi_org is not specified' do
    	assert_raises OFX::Errors::FiOrgMissing do
    		ENV['OFX_FI_ORG'] = nil
    		@doc = OFX::Document.new
    		@doc.send(:fi_org)
    	end
    end

    it 'has an ofx fi_fid' do
      assert_equal @inst[:id], @doc.send(:fi_fid)
    end

    it 'raises an error if fi_id is not specified' do
      assert_raises OFX::Errors::FiFidMissing do
        ENV['OFX_FI_FID'] = nil
        @doc = OFX::Document.new
        @doc.send(:fi_fid)
      end
    end

    it 'has an ofx routing' do
      assert_equal @routing, @doc.send(:routing)
    end

    it 'raises an error if routing is not specified' do
      assert_raises OFX::Errors::RoutingMissing do
        ENV['OFX_ROUTING'] = nil
        @doc = OFX::Document.new
        @doc.send(:routing)
      end
    end

    it 'has an ofx account' do
      assert_equal @account, @doc.send(:account)
    end

    it 'raises an error if account is not specified' do
      assert_raises OFX::Errors::AccountMissing do
        ENV['OFX_ACCOUNT'] = nil
        @doc = OFX::Document.new
        @doc.send(:account)
      end
    end

    it 'has an app id' do
      assert_equal @app[:id], @doc.send(:app_id)
    end

    it 'raises an error if app id is not specified' do
      assert_raises OFX::Errors::AppIdMissing do
        ENV['OFX_APP_ID'] = nil
        @doc = OFX::Document.new
        @doc.send(:app_id)
      end
    end

    it 'has an app ver' do
      assert_equal @app[:ver], @doc.send(:app_ver)
    end

    it 'raises an error if app ver is not specified' do
      assert_raises OFX::Errors::AppVerMissing do
        ENV['OFX_APP_VER'] = nil
        @doc = OFX::Document.new
        @doc.send(:app_ver)
      end
    end

    it 'produces an ofx element group' do
      assert_equal  "OFXHEADER:100\n" \
                    "DATA:OFXSGML\n" \
                    "VERSION:103\n" \
                    "SECURITY:NONE\n" \
                    "ENCODING:UNICODE\n" \
                    "CHARSET:1252\n" \
                    "COMPRESSION:NONE\n" \
                    "OLDFILEUID:NONE\n" \
                    "NEWFILEUID:NONE\n" \
                    "<OFX>" \
                      "<SIGNONMSGSRQV1>" \
                        "<SONRQ>" \
                          "<DTCLIENT>" + @doc.send(:dtclient) + "</DTCLIENT>" \
                          "<USERID>" + @doc.send(:user) + "</USERID>" \
                          "<USERPASS>" + @doc.send(:password) + "</USERPASS>" \
                          "<LANGUAGE>ENG</LANGUAGE>" \
                          "<FI>" \
                            "<ORG>" + @doc.send(:fi_org) + "</ORG>" \
                            "<FID>" + @doc.send(:fi_fid) + "</FID>" \
                          "</FI>" \
                          "<APPID>" + @doc.send(:app_id) + "</APPID>" \
                          "<APPVER>" + @doc.send(:app_ver) + "</APPVER>" \
                        "</SONRQ>" \
                      "</SIGNONMSGSRQV1>" \
                      "<BANKMSGSRQV1>" \
                       "<STMTTRNRQ>" \
                       "<TRNUID>" + @doc.send(:trnuid) + "</TRNUID>" \
                       "<STMTRQ>" \
                         "<BANKACCTFROM>" \
                           "<BANKID>" + @doc.send(:routing).to_s + "</BANKID>" \
                           "<ACCTID>" + @doc.send(:account).to_s + "</ACCTID>" \
                           "<ACCTTYPE>CHECKING</ACCTTYPE>" \
                         "</BANKACCTFROM>" \
                         "<INCTRAN>" \
                           "<DTSTART>20151228000000</DTSTART>" \
                           "<DTEND>20160128000000</DTEND>" \
                           "<INCLUDE>Y</INCLUDE>" \
                         "</INCTRAN>" \
                       "</STMTRQ>" \
                       "</STMTTRNRQ>" \
                      "</BANKMSGSRQV1>" \
                    "</OFX>",
                  @doc.send(:body)
    end
  end
end



