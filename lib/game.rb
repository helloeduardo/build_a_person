
class Game
  attr_reader :secret_word, :guessed_word

  def initialize
    @secret_word = get_secret_word
    @guessed_word = blank_secret_word
    @guesses_left = 12
  end

  def get_secret_word
    dictionary = File.readlines('5desk.txt', chomp: true)
    dictionary.select! do |word|
      word.length.between?(5,12)
    end
    dictionary.sample.downcase.chars
  end

  def blank_secret_word
    secret_word.map { |char|  "_" }
  end

  def start


    until over?
      #display
      #ask
      guess = gets.chomp
      if guess.invalid?
        puts "invalid, try again"
        next
      end
      #update, true if guess matches
    end

  end

  def over?
    true
  end

  def display
    puts "You have #{guesses_left} of guesses left"
    #display array of incorrect letters
    #display board with correct letters filled in
  end

end
