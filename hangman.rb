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


def open_game
  puts "What username did you use to save your file?"
  username = gets.chomp
  play_saved = File.read("saved_games/game_#{username}.txt")
  puts play_saved
end 

def save_game
  puts "What username would you like to use to save your file?"
  username = gets.chomp
  puts "Your file is called game_#{username}.txt"
  
  dirname = "saved_games"
  Dir.mkdir(dirname) unless File.exist? dirname
  
  filename = "saved_games/game_#{username}.txt"
  File.write(filename, Hangman)
end

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
    puts "\n\n\n\n\n Welcome to hangman! Would you like to start a new game or open a saved game?
    Type 'new' for a new game or type 'open' to open a saved game"
    game = gets.chomp
    if game == 'new'
      puts "\n\n\n\n\nThese are the rules and instructions! If you want to quit and save, type 'save' instead of your guess during any turn."
      guesses_remaining = 10
      PlayGame.new($game_word, guesses_remaining)
    elsif game == 'open'
      open_game
    else 
      "Invalid selection. Type 'new' for a new game or type 'open' to open a saved game"
    end 
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
    if guess == 'save'
      puts "end of game"
      $save = true
    elsif guess.length > 1
      puts "Invalid guess. Please only enter one letter with no special characters or spaces"
    elsif($correct.include? guess) || ($incorrect.include? guess) 
      puts "You have already guessed that letter. Please try again."
    elsif @word_arr.include? guess  
        @word_arr.each_with_index do |letter, index| 
          if letter == guess  
            $correct[index] = letter 
          end 
        end 
    else 
      $incorrect.push(guess)
      @guesses -= 1
      $inserted_shapes.insert($incorrect.length-1, $hangman_shapes[$incorrect.length-1])
    end 
    display_update
  end 

  def display_update
    GameBoard.display
    puts "\nCorrect guesses: #{$correct.join}"
    puts "Incorrect guesses: #{$incorrect.join}"
    puts "Remaining guesses: #{@guesses}"
  end 
  

  def play
    until (@word_arr == $correct) || (@guesses == 0) || ($save == true) do 
      puts "\n\nWhat is your guess?"
      user_guess = gets.chomp
      evaluate(user_guess)
    end 

    if @guesses == 0
      puts " The word you were looking for was '#{$game_word}'\n\n"
    
    elsif @word_arr == $correct
      puts "YOU WIN! You are a master wordsmith. Congratulations!\n\n"
    
    elsif $save == true
      puts "You have chosen to save and exit. To reopen this game, start Hangman and type 'open' when prompted."
      save_game
    else
      puts "Hmm something is not working properly..\n\n"
    end 
  end  
end 



$incorrect = []
$inserted_shapes = [" "," "," "," "," "," "," "," "," "," ",]
$hangman_shapes = ["O","|","-","-","/","\\","`","`","_","_"]
$game_word = char_limit(random_line)
$correct = Array.new($game_word.length, "_")
$save = false

Hangman = GameBoard.new
Hangman.beginning






