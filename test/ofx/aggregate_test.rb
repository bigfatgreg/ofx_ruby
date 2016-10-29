# frozen_string_literal: true
require 'test_helper'

class OFX::AggregateTest
  describe OFX::Aggregate do
    before do
      class TestAggregate < OFX::Aggregate; end

      @aggregate = TestAggregate.new(name: :aggregate)
      
      def @aggregate.signon_stuff
        "user"
      end

      def @aggregate.bank_stuff
        "monies"
      end

      @aggregate.class.class_exec do
        protected
        define_method(:order) { %w{ bank_stuff signon_stuff } }
      end
    end

    after do
      @aggregate = nil
    end

    it 'has a label associated with the class' do
      assert_equal :aggregate, @aggregate.send(:tag)
    end


    it 'has a root Aggregate' do
      assert_equal '<AGGREGATE></AGGREGATE>', @aggregate.root
    end

    it 'has elements based on its public methods' do
      assert_includes @aggregate.send(:elements), :signon_stuff, :bank_stuff
    end

    it 'can support ordering of elements' do
      assert @aggregate.send(:ordered?)
      assert_equal @aggregate.send(:elements), [:bank_stuff, :signon_stuff]
    end

    it 'builds an element group' do
      @group = '<AGGREGATE>' \
                 '<BANK_STUFF>monies</BANK_STUFF>' \
                 '<SIGNON_STUFF>user</SIGNON_STUFF>' \
               '</AGGREGATE>'
      assert_equal @group, @aggregate.send(:element_group)
    end
  end
end
