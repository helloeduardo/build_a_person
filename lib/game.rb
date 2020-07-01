require_relative "serializable"

class Game
  include Serializable
  attr_reader :secret_word, :guessed_word, :guesses_left, :guessed_letters

  def initialize
    @secret_word = get_secret_word
    @guessed_word = blank_secret_word
    @guesses_left = 12
    @guessed_letters = []
  end

  def get_secret_word
    dictionary = File.readlines('5desk.txt', chomp: true)
    dictionary.select! do |word|
      word.length.between?(5,12)
    end
    dictionary.sample.upcase.chars
  end

  def blank_secret_word
    secret_word.map { |char|  "_" }
  end

  def start
    check_load
    game_loop
    check_result
  end

  def game_loop
    until over?
      display
      print "Guess a letter or enter 'save' to save game: "
      guess = gets.chomp.upcase
      check_save(guess)
      next if invalid?(guess)
      update(guess)
      @guesses_left -= 1
    end
  end

  def over?
    won? || guesses_left == 0
  end

  def won?
    guessed_word == secret_word
  end

  def check_result
    display

    if won?
      puts "Congratulations, you found the secret word, #{secret_word.join}!"
    else
      puts "Sorry, better luck next time. The word was #{secret_word.join}"
    end
  end

  def display
    puts "\nNumber of guesses left: #{guesses_left}"
    puts "The letters you have guessed are '#{guessed_letters.join}'"
    puts "#{guessed_word.join(" ")}"
  end

  def invalid?(guess)
    if guess.length > 1 || ("A".."Z").to_a.none? {|char| char == guess}
      puts "**Invalid, try again**"
      true
    elsif guessed_letters.include?(guess)
      puts "**Sorry, you've already guessed that letter**"
      true
    end
  end

  def update(guess)
    secret_word.each_with_index do |letter, index|
      if letter == guess
        @guessed_word[index] = letter
      end
    end
    guessed_letters << guess
  end

  def save_game
    Dir.mkdir("saved_games") unless Dir.exists?("saved_games")

    saved_game = "saved_games/saved_game"

    File.open(saved_game, "w") {|file| file.puts self.serialize}

    puts "\n * Game Saved! Goodbye * "

    exit
  end

  def check_save(input)
    save_game if input == "SAVE"
  end

  def load_game
    saved_game = "saved_games/saved_game"

    data = File.read(saved_game)

    self.unserialize(data)

    puts "\n * Hello! Welcome back! * "
  end

  def check_load
    if File.exists?("saved_games/saved_game")
      print "Do you want to load a saved game? (Y/N): "
      input = gets.chomp.upcase
      load_game if input == "Y"
    end
  end

end
