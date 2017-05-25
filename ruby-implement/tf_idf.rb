def tf(word_frequency, word_count)
  Rational(word_frequency, word_count)
end

def idf(document_count, document_frequency)
  Math::log2(Rational(document_count, document_frequency)) + 1
end

def tf_idf(word_frequency, word_count, document_count, document_frequency)
  tf(word_frequency, word_count) * idf(document_count, document_frequency)
end
