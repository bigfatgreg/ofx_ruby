module OFX
  class DTD
    DEFAULT = 103

    @@version = DEFAULT

    class << self
      def version
        @@version
      end

      def set_version(version)
        class_variable_set(:@@version, version)
      end

      def load(version = nil)
        set_version(version) if version
        %w( main sign bank act bill inv mail prof ).inject("") do |result, file|
          result << File.read("dtd/#{@@version}/#{file}.dtd")
        end
      end

      def doctype
        load[/!#{__method__.upcase}\s([A-Z]+)\s/, 1]
      end

      def entities
        load.scan(/<!ENTITY\s+%\s+(.*?)\s+"([^>]+)/)
      end

      def load_entities(entities)
        entities.inject([]) do |result, a|
          result << (a.match(/^%/) ? 
          load[/^<!ENTITY.*?%\s+?#{a.dup.gsub!(/^%/,'')}\s+?"(.*?)"/m, 1] : a) 
        end.to_s.scan(/[A-Z0-9]+/).uniq
      end

      def split_element(element)
        element[0].match(/,/) && 
        element[0].gsub(/(\(|\))/,'').split(',').inject([]) do |result, el|
          result << [el, element[1]]
        end || element
      end

      def elements
        load.scan(/<!ELEMENT\s+(.*?)\s+([^>]+)/)
            .map { |e| split_element(e) }.flatten.each_slice(2)
            .inject([]) { |result, pair| result << pair }
      end

      def load_element(element)
        elements.select { |e| e[0] == element }.inject({}) do |h, v|
          h.update(v[0] => v[1].scan(/%?[A-Z0-9]+/))
        end
      end

      def root
        elements[0]
      end

      def has_children?(element)
        !elements.select { |e| e[0].match(/^#{element}$/) }[0][1].match(/o/)
      rescue
        nil
      end

      def children(element)
        e = load_element(element)
        load_entities(e.values[0]).uniq
      end

      def parents(element)
        ent = entities.select {|e| e[1] =~ /#{element}/ }
        elements.select do |e|
          e[1] =~ /[^\w]#{ent.empty? ? element : ent[0]}[^\w]/
        end.map(&:first)
      end
    end
  end
end
