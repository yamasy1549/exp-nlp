require './tf_idf'

pos = ["記号"]
symbols = []

Dir.open(ARGV[0]).each do |file_name|
  next if file_name =~ /^\.+$/
  File.open(File.join(ARGV[0], file_name)) do |file|
    text = file.read.chomp
    symbols << text.remove_url.wakati(pos).uniq
  end
end

puts symbols.flatten.uniq

# ruby mecab_symbol.rb ./data
