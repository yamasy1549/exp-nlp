require 'pry'
require 'uri'
require 'natto'

class Array
  def ngram(n)
    self.each_cons(n).map(&:join)
  end
end

class String
  def ngram(n)
    self.split('').each_cons(n).map(&:join)
  end

  def wakati(pos)
    nm = Natto::MeCab.new('-S%f[6] -F%f[0] -E"') # -E で何か指定しなきゃいけない
    wakati_array = 
      nm.enum_parse(self).map do |n|
        if pos
          pos.include?(n.feature) ? n.surface : nil
        else
          n.surface
        end
      end
    wakati_array.compact!.delete("\"") # EOFを消す
    wakati_array
  end

  def remove_url
    self.gsub(URI.regexp, '')
  end

  def remove_symbols
    self.gsub(/[\n\[\]:;!"#&'()*+,-.\/<=\?^{\|}°×δζημν—“”…‰′″※↑→↓⇒⇔−∞■□○●★☆　、。〈〉《》「」『』【】〒〔〕〜ノ・！＆（）＊＋／：；＝？［］]/, '')
  end
end

def tf(freq, all)
  Rational(freq, all)
end

def idf(n, df)
  Math::log2(Rational(n, df)) + 1
end

def tf_idf(freq, all, n, df)
  tf(freq, all) * idf(n, df)
end

class WordsTable < Hash
  def collect_words(ngram, file_name)
    ngram.uniq.each do |name|
      self[name] ||= {}
      self[name][file_name] = ngram.grep(name).count
    end
  end
end
