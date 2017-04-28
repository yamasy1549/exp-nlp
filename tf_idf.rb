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

  def wakati
    nm = Natto::MeCab.new('-S%f[6] -F%f[6] -E\n')
    nm.enum_parse(self).map do |n|
      n.feature
    end
  end
end

def tf(frec, all)
  Rational(frec, all)
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
