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
require 'yaml'


class Word
  attr_reader :game_word
  def initialize
    @game_word = char_limit(random_line)
  end

  private
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
end


class GameBoard
  attr_reader :game_word
  def initialize
    @game_word = Word.new.game_word
    beginning
  end 

  def beginning
    puts "\n\n\n\n\n Welcome to hangman! Would you like to start a new game or open a saved game?
    Type 'new' for a new game or type 'open' to open a saved game"
    game = gets.chomp
    if game == 'new'
      puts "\n\n\n\n\nInstructions: You have 10 guesses to figure out the secret word. Only incorrect guesses will count against you. If you want to quit and save, type 'save' instead of your guess during any turn."
      guesses_remaining = 10
      PlayGame.new(@game_word, guesses_remaining)
    elsif game == 'open'
      PlayGame.load_game
    else 
      "Invalid selection. Type 'new' for a new game or type 'open' to open a saved game"
      beginning
    end  
  end

  def self.display
    @display = puts "      
          ___
          |   |
          #{$inserted_shapes[0]}   |
        #{$inserted_shapes[6]}#{$inserted_shapes[2]}#{$inserted_shapes[1]}#{$inserted_shapes[3]}#{$inserted_shapes[7]} |
        #{$inserted_shapes[8]}#{$inserted_shapes[4]} #{$inserted_shapes[5]}#{$inserted_shapes[9]} |
          ____|____"
  end 
end 


class PlayGame < GameBoard
  attr_accessor :word, :word_arr, :guesses, :correct, :incorrect, :save
  def initialize(word, guesses)
    @word = word
    @word_arr = @word.split("")
    @guesses = guesses
    @correct = Array.new(@word.length, "_")
    @incorrect = Array.new
    @save = false
    play
  end 
  
  def play
    until (@word_arr == @correct) || (@guesses == 0) || (@save == true) do 
      puts "\n\nWhat is your guess?"
      user_guess = gets.chomp
      evaluate(user_guess)
    end 

    if @guesses == 0
      puts " The word you were looking for was '#{@word}'\n\n"
    
    elsif @word_arr == @correct
      puts "YOU WIN! You are a master wordsmith. Congratulations!\n\n"
    
    elsif @save == true
      puts "You have chosen to save and exit. To reopen this game, start Hangman and type 'open' when prompted."
    else
      puts "Hmm something is not working properly..\n\n"
    end 
  end  

  def evaluate(guess)
    if guess == 'save'
      puts "end of game"
      @save = true
      save_game
    elsif guess.length > 1
      puts "Invalid guess. Please only enter one letter with no special characters or spaces"
    elsif(@correct.include? guess) || (@incorrect.include? guess) 
      puts "You have already guessed that letter. Please try again."
    elsif @word_arr.include? guess  
        @word_arr.each_with_index do |letter, index| 
          if letter == guess  
            @correct[index] = letter 
          end 
        end 
    else 
      @incorrect.push(guess)
      @guesses -= 1
      $inserted_shapes.insert(@incorrect.length-1, $hangman_shapes[@incorrect.length-1])
    end 
    display_update
  end 

  def display_update
    GameBoard.display
    puts "\nCorrect guesses: #{@correct.join}"
    puts "Incorrect guesses: #{@incorrect.join}"
    puts "Remaining guesses: #{@guesses}"
  end 

  def save_game
    puts "What username would you like to use to save your game?"
    username = gets.chomp
    dirname = "saved_games"
    Dir.mkdir(dirname) unless File.exist? dirname
    puts "You game file is called 'saved_games/game_#{username}.yml"
    
    filename = "saved_games/game_#{username}.yml"
    File.open(filename, 'w') { |f| YAML.dump([] << self, f) }
    exit
  end 

  

  def self.load_game
    unless Dir.exist?('saved_games')
      puts 'No saved games found. Starting new game...'
      sleep(5)
      return
    end
    games = saved_games
    deserialize(load_file(games))
  end

  def self.load_file(games)
    loop do
      puts "What username did you use to save your game?"
      username = gets.chomp
      file = "game_#{username}"
      return username if saved_games.include?(file)
      puts 'The game you requested does not exist.'
    end
  end 

  def self.deserialize(username)
    yaml = YAML.load_file("./saved_games/game_#{username}.yml")
     
    @word = yaml[0].word
    @word_arr = yaml[0].word_arr
    @guesses = yaml[0].guesses
    @correct = yaml[0].correct
    @incorrect = yaml[0].incorrect
    @save = yaml[0].save 

    #  PlayGame.new(@word, @guesses)
  end

  def self.saved_games
    Dir['./saved_games/*'].map { |file| file.split('/')[-1].split('.')[0] }
  end

end 


$inserted_shapes = [" "," "," "," "," "," "," "," "," "," ",]
$hangman_shapes = ["O","|","-","-","/","\\","`","`","_","_"]

Hangman = GameBoard.new






