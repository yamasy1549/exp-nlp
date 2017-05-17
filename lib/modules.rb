module ArrayEx
  refine Array do
    def ngram(n)
      self.each_cons(n).map(&:join)
    end
  end
end

module HashEx
  refine Hash do
    def collect_words(ngram, file_name)
      ngram.uniq.each do |name|
        self[name] ||= {}
        self[name][file_name] = ngram.grep(name).count
      end
      self
    end

    def max_value
      self.max { |a, b| a[1] <=> b[1] }[1]
    end

    def min_value
      self.min { |a, b| a[1] <=> b[1] }[1]
    end
  end
end

module StringEx
  refine String do
    require 'uri'
    require 'natto'

    def ngram(n)
      self.split('').each_cons(n).map(&:join)
    end

    def wakati(pos=nil)
      nm = Natto::MeCab.new('-S%f[6] -F%f[0]')
      words = nm.enum_parse(self).map { |n| n.surface if pos.nil? || pos.include?(n.feature) }
      words.compact.reject(&:empty?)
    end

    def remove_url
      self.gsub(URI.regexp, '')
    end

    def remove_symbols
      nm = Natto::MeCab.new('-S%f[6] -F%f[0]')
      words = nm.enum_parse(self).map { |n| n.surface if n.char_type != 3 }
      words.compact.join('')
    end
  end
end
