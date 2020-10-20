#-----Psuedocode-----
# 1. Load dictionary 
# 2. Choose random word between 5 and 12 characters
# 3. Add hangman interface 
# 4. Display letters chosen so far: correct and incorrect 
#     - Make chosen word an array and match the correct letter to #index_of
# 5. Create turns, prompt for user guess 
# 6. Update the display after each turn 
#     - write to the document for purposes of saving the file 
# 7. If guesses = 0, end the game and reveal the word 
# 8. Give player the option to save and quit at the beginning of each turn 
# 9. At beginning, allow new game to start or open and continue saved game 


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
  puts "\n\n\n\n\nThese are the rules and instructions!"
  puts "      
         ___
        |   |
            |
            |
            |
        ____|____"
end 


class PlayGame
  def initialize(word, guesses)
    @word = word
    @guesses = guesses
    puts "\n\nWhat is your guess?"
    user_guess = gets.chomp
    evaluate(user_guess)

  end 
  
  
  def evaluate(guess)
    if @word.include? guess  
      puts "correct!" 
    else 
      puts "try again please"
    end 
  end 

  #puts "You guessed #{user_guess}."
end 




game_word = char_limit(random_line)  
guesses_remaining = 10
hangman = GameBoard.new
PlayGame.new(game_word, guesses_remaining)
puts guesses_remaining
puts game_word

puts "      
   ___
  |   |
  O   |
`-|-` |
_/ \\_ |
  ____|____"

