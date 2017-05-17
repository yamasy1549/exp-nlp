require './modules'
require './tf_idf'

using ArrayEx
using HashEx
using StringEx

N = ARGV[0]
INPUT_DIR = ARGV[1]
OUTPUT_DIR = ARGV[2]

pos = ["名詞", "動詞", "形容詞", "副詞", "感動詞"]
word_table = {}
source_files = {}

Dir.open(INPUT_DIR).each do |file_name|
  next if file_name =~ /^\.+$/
  File.open(File.join(INPUT_DIR, file_name)) do |file|
    ngram = file.read.chomp.remove_url.remove_symbols.wakati(pos).ngram(N.to_i)
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
  File.open(File.join(OUTPUT_DIR, "#{filename}-#{N}gram"), 'w') do |file|
    words_tf_idf.each { |word_tf_idf| file.puts word_tf_idf }
  end
end

# ruby mecab_ngram.rb 2 ./data ./result-word
