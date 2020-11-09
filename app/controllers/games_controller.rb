require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet.sample }
  end

  def score
    @result = { score: 1, message: '', word: params[:word] }
    @result = check_grid(params[:word], params[:letters].split(''), @result)
    return @result if @result[:score].zero?

    @result = parse_json(params[:word], @result)
    store_score(@result)
    @score = session[:score]
  end

  private

  def check_grid(word, grid, result)
    word.split('').each do |letter|
      result[:score] = 0 unless grid.include? letter.upcase
      result[:message] = "can't be built out of the grid" unless grid.include? letter.upcase
      index = grid.find_index(letter.upcase)
      grid.delete_at(index) if index
    end
    result
  end

  def parse_json(word, result)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    valid = JSON.parse(open(url).read)
    if valid['found']
      result[:score] = word.size**2
      result[:message] = 'is a valid English word!'
    else
      result[:score] = 0
      result[:message] = 'does not seem to be a valid English word...'
    end
    result
  end

  def store_score(result)
    if session[:score]
      session[:score] += result[:score]
    else
      session[:score] = result[:score]
    end
  end
end
