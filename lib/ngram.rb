require './modules'
require './tf_idf'

using ArrayEx
using HashEx
using StringEx

def compile_words(input_files, word_table, source_files)
  input_files.each do |file_name|
    File.open(file_name) do |file|
      basename = File.basename(file)
      ngram = file.read.remove_url.remove_symbols.ngram(N.to_i)
      word_table.collect_words(ngram, basename)
      source_files[basename] = ngram.count
      puts "#{basename} checked"
    end
  end
  return word_table, source_files
end

N, INPUT_DIR, OUTPUT_DIR = ARGV

word_table, source_files = compile_words(Dir.glob("#{INPUT_DIR}/**/*"), {}, {})

word_table = Hash[word_table.sort]
d_count = source_files.count

source_files.each do |file_name, w_count|
  tf_idf_list = {}
  word_table.each do |word_name, word_count_in|
    w_frequency = word_count_in[file_name]
    d_frequency = word_count_in.count
    if w_frequency && w_count && d_count && d_frequency
      tf_idf_list[word_name] = tf_idf(w_frequency, w_count, d_count, d_frequency)
    end
  end

  threshold = (tf_idf_list.max_value - tf_idf_list.min_value) * (1-(N.to_i-1)*0.5) * 0.1

  File.open(File.join(OUTPUT_DIR, "#{file_name}-#{N}gram"), 'w') do |file|
    tf_idf_list.each do |word, tf_idf|
      file.puts "#{word}\t#{tf_idf}" if tf_idf > threshold
    end
  end
end

# ruby ngram.rb 2 ./data ./result-character
