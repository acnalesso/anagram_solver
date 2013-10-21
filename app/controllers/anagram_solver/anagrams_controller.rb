module AnagramSolver

  class AnagramsController < ApplicationController

    def index
      @anagrams = Anagram.all
    end

  end

end
