# frozen_string_literal: true
module OFX
  class Aggregate
    attr_reader :tag
    protected :tag

    def initialize(options = {})
      @tag = options[:name] || :ofx
    end

    def root
      dump(@tag)
    end

    protected

    def dump(element, body = nil)
      tag = element.upcase
      "<#{tag}>#{body}</#{tag}>"
    end

    def elements
      respond_to?(:order, true) ? sort_by_order : public_methods(false)
    end
    
    def ordered?
      respond_to?(:order, true)
    end
    
    def sort_by_order
      public_methods(false).sort_by { |element| order.index(element.to_s) }
    end
    
    def build_element_group(tag)
      if send(tag).respond_to?(:element_group, true)
        send(tag).send(:element_group)
      else
        dump(tag, send(tag))
      end
    end
    
    def element_group
      body = elements.inject('') do |result, tag|
        result.dup << build_element_group(tag)
      end
      dump(@tag, body)
    end
  end
end
