require 'csv'

def search_or(search_words, dirname)
  result = []
  Dir.open(dirname).each do |file_name|
    next if file_name =~ /^\.+$/
    File.open(File.join(ARGV[0], file_name)) do |file|
      csv_data = CSV.read(file, col_sep: "\t", headers: false)
      csv_data.each do |row|
        search_words = [search_words] if search_words.class == String
        result << row[1..-1] if search_words.include?(row[0])
      end
    end
  end
  result.flatten.uniq
end

def search_and(search_words, dirname)
  search_words.map do |search_word|
    search_or(search_word, dirname)
  end.inject(&:&)
end

def prioritize(files)
  file_tf_idf = {}
  dirs = ['./result-character-removed', './result-word-removed']

  files.each do |data_file|
    dirs.each do |dir|
      Dir.open(dir).each do |file_name|
        next unless file_name =~ /#{data_file}(.*)gram/
        File.open(File.join(dir, file_name)) do |file|
          file.read.split("\n").each do |word|
            match = word.match(/(.*)\t(.*)/)
            if ARGV[1..-1].include?(match[1])
              file_tf_idf[data_file] = 0 unless file_tf_idf[data_file]
              file_tf_idf[data_file] += match[2].to_f
            end
          end
        end
      end
    end
  end

  # Hash[file_tf_idf.sort_by{ |_, v| -v }]
  Hash[file_tf_idf.sort_by{ |_, v| -v }].map{ |k, _| k }
end

search_result = search_or(ARGV[1..-1], ARGV[0])
search_result = search_and(ARGV[1..-1], ARGV[0])
puts prioritize(search_result)

# ruby search.rb ./result-transpose オオサンショウウオ
