module AnagramSolver

  class AnagramsController < ApplicationController

    def index
      @anagrams = AnagramSolver::Anagram.all
    end

  end

end
