def random_line
  dictionary = File.readlines("dictionary.txt")
  line_number = rand(0..(dictionary.length)) 
  chosen_line = dictionary[line_number].chomp
  chosen_line
end

def char_limit(word)
  if word.length > 12
    char_limit(random_line)
  elsif word.length < 5
    char_limit(random_line)
  else 
    word
  end
end 

puts char_limit(random_line)


