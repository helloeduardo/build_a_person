
class Game
  attr_reader :secret_word, :guessed_word

  def initialize
    @secret_word = get_secret_word
    @guessed_word = blank_secret_word
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

end
