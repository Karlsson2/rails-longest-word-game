require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @start_time = Time.now()

    @letters_string = @letters.join()
  end

  def score
    @end_time = Time.now()
    @letters = params[:letters].split("")
    @start_time = Time.parse(params[:startTime])
    @time = @end_time - @start_time
    @attempt = params[:attempt].upcase
    @return_hash = {}
    @score = 0
    @message = ""

    if !double_letters?(@attempt, @letters) && is_english(@attempt) && appears_in_grid(@attempt, @letters)
      #calculate points
      @score = @attempt.length
      @message = "Congratulations! #{@attempt} is a valid English word!"

      if @time <= 5
        @score = @score + 10
      else
        @score = @score + 5
      end

    elsif double_letters?(@attempt, @letters) || !appears_in_grid(@attempt, @letters)
      #return false message for having double letters
      @score = 0
      @message = "Sorry but #{@attempt} uses too many of the same letter in: #{@letters.to_s}"
    elsif !is_english(@attempt)
      @score = 0
      @message = "Sorry but #{@attempt} does not seem to be a valid english word"
    end
    @return_hash = {score: @score, message: @message, time: @time}
  end

  def is_english(attempt)
    base_url = "https://wagon-dictionary.herokuapp.com/"
    url = base_url + attempt

    data = open(url).read
    json = JSON.parse(data)
    return json["found"]
  end

  def appears_in_grid(attempt, letters)
  # attempt = "string", letters ="string"

    attempt_chars = attempt.upcase.chars
    counter = 0

    attempt_chars.each do |letter|
      counter += 1 if letters.include?(letter)
    end

    counter == attempt_chars.length
  end

  def double_letters?(attempt, letters)
  # return false if a letter  twice in the attempt
  # but only once in the
    attempt_chars = attempt.upcase.chars

    return_value = attempt_chars.find do |letter|
      attempt_chars.count(letter) > letters.count(letter)
    end
    p return_value
    return_value.nil? ? (return_value = false) : (return_value = true)
      return return_value
  end


end
