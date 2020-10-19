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


class GameBoard
  puts "      
         ___
        |   |
            |
            |
            |
        ____|____"

  game_word = char_limit(random_line)
  guesses_remaining = 10
  puts guesses_remaining
  puts game_word

end 

hangman = GameBoard.new

puts "      
   ___
  |   |
  O   |
`-|-` |
_/ \\_ |
  ____|____"

