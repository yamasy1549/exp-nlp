require './tf_idf'

pos = ["名詞", "動詞", "形容詞", "副詞", "感動詞"]
word_table = WordsTable.new
source_files = {}

Dir.open(ARGV[1]).each do |file_name|
  next if file_name =~ /^\.+$/
  File.open(File.join(ARGV[1], file_name)) do |file|
    ngram = file.read.chomp.remove_url.remove_symbols.wakati(pos).ngram(ARGV[0].to_i)
    word_table.collect_words(ngram, file_name)
    source_files[file_name] = ngram.count
    puts "#{file_name} checked"
  end
end

word_table = word_table.sort
all_file_count = source_files.count

source_files.each do |filename, word_count|
  words_tf_idf = []
  word_table.each do |name, word_count_in|
    freq = word_count_in[filename]
    df = word_count_in.count
    if freq && word_count && all_file_count && df
      tf_idf = tf_idf(freq, word_count, all_file_count, df)
      words_tf_idf << "#{name}\t#{tf_idf}"
    end
  end
end

word_table = Hash[word_table]

File.open(File.join(ARGV[2], "word-#{ARGV[0]}gram.txt"), 'w') do |file|
  word_table.each do |word, files|
    file.puts "#{word}\t#{files.map { |k, _v| k }.join("\t")}"
  end
end

# ruby transpose_index_mecab_ngram.rb 1 ./data ./result-transpose
