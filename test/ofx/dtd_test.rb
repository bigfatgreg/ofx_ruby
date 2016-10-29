# frozen_string_literal: true
require 'test_helper'

class OFX::DTDTest
  describe OFX::DTD do
    before do
      @dtd = OFX::DTD
    end

    after do
      @dtd.set_version(103)
    end

    it "has a default version number" do
      assert_equal 103, @dtd::DEFAULT
      assert_equal 103, @dtd.class_variable_get(:@@version)
    end
    
    it "loads a dtd based on the version #" do
      assert @dtd.load
      assert @dtd.load(102)
    end

    it "knows its doctype" do
      assert_equal "OFX", @dtd.doctype
    end

    it "finds entities" do
      assert_equal 31, @dtd.entities.length
    end

    it "loads entity definitions" do
      assert_equal @dtd.load_entities(["%MSGSETMACRO"]), 
                   %w{ SIGNUPMSGSET BANKMSGSET CREDITCARDMSGSET INVSTMTMSGSET
                       INTERXFERMSGSET WIREXFERMSGSET BILLPAYMSGSET 
                       EMAILMSGSET SECLISTMSGSET EXTRAMSGSETS }
      assert_equal @dtd.load_entities(["%OFXRQMSGSETS"]), 
                   %w{ SIGNONMSGSRQV1 SIGNUPMSGSRQV1 BANKMSGSRQV1
                       CREDITCARDMSGSRQV1 INVSTMTMSGSRQV1 INTERXFERMSGSRQV1
                       WIREXFERMSGSRQV1 BILLPAYMSGSRQV1 EMAILMSGSRQV1
                       SECLISTMSGSRQV1 PROFMSGSRQV1 EXTRARQMSGSETS }
    end

    it "finds elements" do
      assert_equal 678, @dtd.elements.length
      assert_includes @dtd.elements.map(&:first), "BANKACCTFROM" 
    end

    it "loads a parsed element" do
      assert_equal @dtd.load_element('CCACCTTO'), 
                   { "CCACCTTO" => ["ACCTID" , "ACCTKEY"] }
    end

    it "finds the root element" do
      assert_equal "OFX", @dtd.root[0]
    end

    it "knows if an element has children" do
      assert @dtd.has_children?("OFX")
      assert @dtd.has_children?("STATUS")
      assert @dtd.has_children?("FI")
      refute @dtd.has_children?("CODE")
    end

    it "splits a compound element" do
      assert_equal ["CCACCTTO", "- - (ACCTID , ACCTKEY?)"],
                   @dtd.split_element(["(CCACCTTO, CCACCTFROM)",
                                       "- - (ACCTID , ACCTKEY?)"])[0]
    end

    it "gets an element's children" do
      assert_equal @dtd.children('BANKACCTFROM'),
                   %w{ BANKID BRANCHID ACCTID ACCTTYPE ACCTKEY }
      assert_equal @dtd.children('BANKACCTTO'),
                   %w{ BANKID BRANCHID ACCTID ACCTTYPE ACCTKEY }
      assert_equal @dtd.children('OFX'),
                   %w{ SIGNONMSGSRQV1 SIGNUPMSGSRQV1 BANKMSGSRQV1 
                       CREDITCARDMSGSRQV1 INVSTMTMSGSRQV1 INTERXFERMSGSRQV1 
                       WIREXFERMSGSRQV1 BILLPAYMSGSRQV1 EMAILMSGSRQV1 
                       SECLISTMSGSRQV1 PROFMSGSRQV1 EXTRARQMSGSETS 
                       SIGNONMSGSRSV1 SIGNUPMSGSRSV1 BANKMSGSRSV1 
                       CREDITCARDMSGSRSV1 INVSTMTMSGSRSV1 INTERXFERMSGSRSV1 
                       WIREXFERMSGSRSV1 BILLPAYMSGSRSV1 EMAILMSGSRSV1 
                       SECLISTMSGSRSV1 PROFMSGSRSV1 EXTRARSMSGSETS }            
      assert_equal @dtd.children('SONRQ'),
                   %w{ DTCLIENT USERID USERPASS USERKEY GENUSERKEY LANGUAGE FI 
                       SESSCOOKIE APPID APPVER CLIENTUID USERCRED1 USERCRED2 
                       AUTHTOKEN ACCESSKEY MFACHALLENGEANSWER }
      assert_equal @dtd.children('MFACHALLENGEANSWER'),
                   %w{ MFAPHRASEID MFAPHRASEA }
      assert_equal @dtd.children('BAL'),
                   %w{ NAME DESC BALTYPE VALUE DTASOF CURRENCY}
      assert_equal @dtd.children('RECPMTMODRQ'),
                   %w{ RECSRVRTID RECURRINST PMTINFO INITIALAMT FINALAMT 
                       MODPENDING }
      assert_equal @dtd.children('BILLPAYMSGSETV1'),
                   %w{ MSGSETCORE DAYSWITH DFLTDAYSTOPAY XFERDAYSWITH 
                       XFERDFLTDAYSTOPAY PROCDAYSOFF PROCENDTM MODELWND 
                       POSTPROCWND STSVIAMODS PMTBYADDR PMTBYXFER PMTBYPAYEEID 
                       CANADDPAYEE HASEXTDPMT CANMODPMTS CANMODMDLS 
                       DIFFFIRSTPMT DIFFLASTPMT }
      assert_equal @dtd.children('PMTTRNRQ'),
                   %w{ TRNUID CLTCOOKIE TAN PMTRQ PMTMODRQ PMTCANCRQ }
      assert_equal @dtd.children('RECPMTTRNRQ'),
                   %w{ TRNUID CLTCOOKIE TAN RECPMTRQ RECPMTMODRQ RECPMTCANCRQ }
      assert_equal @dtd.children('PAYEETRNRQ'),
                   %w{ TRNUID CLTCOOKIE TAN PAYEERQ PAYEEMODRQ PAYEEDELRQ }
      
      assert_equal @dtd.children('CCACCTFROM'), %w{ ACCTID ACCTKEY }
      assert_equal @dtd.children('CCACCTTO'), %w{ ACCTID ACCTKEY }
      assert_equal @dtd.children('FI'), %w{ ORG FID }
      assert_equal @dtd.children('STATUS'), %w{ CODE SEVERITY MESSAGE }
      assert_equal @dtd.children('PMTINQTRNRQ'),
                   %w{ TRNUID CLTCOOKIE TAN PMTINQRQ }
      assert_equal @dtd.children('PMTMAILTRNRQ'),
                   %w{ TRNUID CLTCOOKIE TAN PMTMAILRQ }
    end

    it "knows an element's possible parent" do
      assert @dtd.parents("OFX").empty?
      assert_includes @dtd.parents("BANKID"), "BANKACCTFROM"
      assert_includes @dtd.parents("BANKMSGSRSV1"), "OFX"
      assert_includes @dtd.parents("DTSERVER"), "SONRS"
    end
  end
end
