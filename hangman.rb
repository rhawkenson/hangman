#-----Psuedocode-----
# 1. Load dictionary 
# 2. Choose random word between 5 and 12 characters
# 3. Add hangman interface 
# 4. Display letters chosen so far: correct and incorrect 
#     - Make chosen word an array and match the correct letter to #index_of
#     - Do not allow the user to guess the same letter more than once
# 5. Create turns, prompt for user guess 
# 6. Update the display after each turn 
#     - Write to the document for purposes of saving the file 
#     - Base the stick man's growths on the length of a guesses array
#     - Add all occurrences of the letter in the word to the display
# 7. If guesses = 0, end the game and reveal the word 
# 8. Give player the option to save and quit at the beginning of each turn 
# 9. At beginning, allow new game to start or open and continue saved game 
$incorrect = []
$inserted_shapes = [" "," "," "," "," "," "," "," "," "," ",]
$hangman_shapes = ["O","|","-","-","/","\\","`","`","_","_"]

def random_line
  dictionary = File.readlines("dictionary.txt")
  line_number = rand(0..(dictionary.length)) 
  chosen_line = dictionary[line_number].downcase.chomp
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
  def beginning
    puts "\n\n\n\n\nThese are the rules and instructions!"
  end
  def self.display
    
    puts "      
           ___
          |   |
          #{$inserted_shapes[0]}   |
        #{$inserted_shapes[6]}#{$inserted_shapes[2]}#{$inserted_shapes[1]}#{$inserted_shapes[3]}#{$inserted_shapes[7]} |
        #{$inserted_shapes[8]}#{$inserted_shapes[4]} #{$inserted_shapes[5]}#{$inserted_shapes[9]} |
          ____|____"
  end 
end 


class PlayGame
  def initialize(word, guesses)
    @word = word
    @word_arr = @word.split("")
    @guesses = guesses
    play
  end 

  
  def evaluate(guess)
    if @word_arr.include? guess  
      $correct[@word_arr.index(guess)] = guess 
    else 
      $incorrect.push(guess)
      @guesses -= 1
      $inserted_shapes.insert($incorrect.length-1, $hangman_shapes[$incorrect.length-1])
    end 
    display_update
  end 

  def display_update
    GameBoard.display
    puts "Correct guesses: #{$correct.join}"
    puts "Incorrect guesses: #{$incorrect.join}"
  end 
  

  def play
    until (@word_arr == $correct) || (@guesses == 0) do 
      puts "\n\nWhat is your guess?"
      user_guess = gets.chomp
      evaluate(user_guess)
    end 
  end 
end 

  #puts "You guessed #{user_guess}."




game_word = char_limit(random_line) 
$correct = Array.new(game_word.length, "_")
guesses_remaining = 10
hangman = GameBoard.new
PlayGame.new(game_word, guesses_remaining)


puts " The word you were looking for was '#{game_word}'"


