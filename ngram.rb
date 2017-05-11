require './tf_idf'

word_table = WordsTable.new
source_files = {}

Dir.open(ARGV[1]).each do |file_name|
  next if file_name =~ /^\.+$/
  File.open(File.join(ARGV[1], file_name)) do |file|
    ngram = file.read.remove_url.remove_symbols.ngram(ARGV[0].to_i)
    word_table.collect_words(ngram, file_name)
    source_files[file_name] = ngram.count
    puts "#{file_name} checked"
  end
end

word_table = word_table.sort
all_file_count = source_files.count

source_files.each do |filename, word_count|
  words_tf_idf = []
  tf_idf_list = []
  word_table.each do |name, word_count_in|
    freq = word_count_in[filename]
    df = word_count_in.count
    if freq && word_count && all_file_count && df
      tf_idf = tf_idf(freq, word_count, all_file_count, df)
      tf_idf_list << tf_idf
      words_tf_idf << "#{name}\t#{tf_idf}"
    end
  end

  threshold = (tf_idf_list.max - tf_idf_list.min) * (1-(3-(ARGV[0].to_i-1)*0.5)) * 0.1

  File.open(File.join(ARGV[2], "#{filename}-#{ARGV[0]}gram"), 'w') do |file|
    words_tf_idf.each do |word_tf_idf|
      if word_tf_idf.match(/(?:.*)\t(.*)/)[1].to_f > threshold
        file.puts word_tf_idf
      end
    end
  end
end

# ruby ngram.rb 2 ./data ./result-character
