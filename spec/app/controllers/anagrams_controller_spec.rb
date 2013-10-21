require 'spec_helper'
require 'controllers/anagram_solver/anagrams_controller'

class AnagramSolver::Anagram
  ##
  # Stubs anagram's 'all' class object method.
  #
  def self.all; [:test]; end
end

describe AnagramSolver::AnagramsController do

  let(:anagram) { AnagramSolver::AnagramsController.new }

  describe "#index" do

    before { anagram.index }

    it "must have index action" do
      anagram.should respond_to :index
    end

    it "must setup @anagrams instance var" do
      anagrams = anagram.instance_variable_get(:@anagrams)
      anagrams.should_not be_nil
    end

  end

end
