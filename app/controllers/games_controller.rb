require 'json'
require "open-uri"

class GamesController < ApplicationController
    def new
        @grid = [ 'Y', 'Z', 'D', 'U', 'E', 'Z', 'Y', 'Q', 'I' ]
    end

    def score
        # TODO: auto generate the grid
        grid = [ 'Y', 'Z', 'D', 'U', 'E', 'Z', 'Y', 'Q', 'I' ]
        # user input striped down
        @attempt = params[:my_score].strip
        # matches user input with le wagon api true/false
        @trans = get_translation(@attempt)
        # checks if user input is an actual english word
        if @trans
            if included?(@attempt.upcase.split(""), grid)
                @game_score = 1
            else
                @game_score = 0
            end
        end
    end

    def included?(guess, grid)
        guess.all? { |letter| guess.count(letter) <= grid.count(letter) }
        
    end

    def get_translation(word)
        url = "https://wagon-dictionary.herokuapp.com/#{word}"
        user_serialized = URI.open(url).read
        user = JSON.parse(user_serialized)
        return user['found']
    end
end
