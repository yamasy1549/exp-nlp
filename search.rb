require 'pry'
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

puts search_and(ARGV[1..-1], ARGV[0])

# ruby search.rb ./result-transpose オオサンショウウオ
