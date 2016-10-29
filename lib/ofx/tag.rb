# frozen_string_literal: true
module OFX
  class Tag
    attr_reader :name

    def initialize(parser, name, options = {})
      @name = name.to_s.upcase
      @parser = parser
      @document = @parser.body
      @index = options[:index] || 0
    end

    def list
      @document.scan(tag).each_with_index.inject([]) do |list, (tag, index)|
        list << to_tag(tag, { index: index })
      end
    end

    def has_closing?
    	!@document.index("</#@name>").nil?
    end

    def tag
      "<#@name>"
    end

    def closing
      has_closing? && "</#@name>"
    end

    def preceeding_tags
      i = @document.index(tag)
      tags = @document[0..i].scan(/<\/?[A-Z0-9]+>/).reverse
      !tags.empty? && tags || nil
    end

    def parent
      parent = preceeding_tags && preceeding_tags.select do |tag|
        t = to_tag(tag)
        t.has_closing? && !preceeding_tags.include?(t.closing)
      end.first
      parent && to_tag(parent) || nil
    end

    def children
      has_closing? && contents.scan(/<[A-Z0-9]+>/).map { |t| to_tag(t) }
                              .select { |g| g.parent && g.parent.name == @name }
    end

    def position
      if list.count > 1
        initial_position = @document.index(tag)
        (0..@index).each do |i|
          initial_position = @position || 0
          @position = @document.index(tag, initial_position + 1)
        end
      else
        @document.index(tag)
      end
      @position
    end

    def contents
      if has_closing? && list.count == 1
        s = @document.index(tag) + tag.length
        e = @document.index(closing) - 1
        @document[s..e]
      elsif has_closing?
        s = position + tag.length
        e = @document.index('</', @position + tag.length) - 1
        @document[s..e]
      else
        to_tag(tag).list
      end
    end

    private
    
    def to_tag(name, options = {})
      n = name.gsub(/(<|>|\/)/,'').downcase.to_sym
      self.class.new(@parser, n, options)
    end    
  end
end
