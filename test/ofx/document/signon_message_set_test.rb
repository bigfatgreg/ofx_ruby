# frozen_string_literal: true
require 'test_helper'

class OFX::SignonMessageSetTest
  describe OFX::Document::SignonMessageSet do
    before do
      @user = 'ofx_uer'
      @password = 'password'
      @dtclient = Time.now.strftime('%Y%m%d%H%M%S')
      @fi_org = 'hhh'
      @fi_fid = '575'
      @app_id = 'QBW'
      @app_ver = '333'
      @signon = OFX::Document::SignonMessageSet.new(
        name: :signonmsgsrqv1,
        user: @user,
        password: @password,
        time: @dtclient,
        fi_org: @fi_org,
        fi_fid: @fi_fid,
        app_id: @app_id,
        app_ver: @app_ver
      )
    end

    it 'produces a stmtrq aggregate' do
      assert_equal '<SIGNONMSGSRQV1>' \
                  	'<SONRQ>' \
                  		'<DTCLIENT>' + @dtclient + '</DTCLIENT>' \
                  		'<USERID>' + @user + '</USERID>' \
                  		'<USERPASS>' + @password + '</USERPASS>' \
                  		'<LANGUAGE>ENG</LANGUAGE>' \
                  		'<FI>' \
                  			'<ORG>' + @fi_org + '</ORG>' \
                  			'<FID>' + @fi_fid + '</FID>' \
                  		'</FI>' \
                  		'<APPID>' + @app_id + '</APPID>' \
                  		'<APPVER>' + @app_ver + '</APPVER>' \
                  	'</SONRQ>' \
                  '</SIGNONMSGSRQV1>',
                  @signon.send(:element_group)
    end
  end
end

