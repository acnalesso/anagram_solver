require 'spec_helper'
ApplicationController = Class.new
Anagram = Class.new
require 'controllers/anagram_solver/anagrams_controller'

##
# Make tests run faster by not loading
# rails.
#
describe AnagramSolver::AnagramsController do

  let(:anagram) { AnagramSolver::AnagramsController.new }

  it "must have index action" do
    anagram.should respond_to :index
  end

  describe "#index" do
    it "must return array of searched anagramms" do
      Anagram.should_receive(:all).
      and_return([:test])

      expect(anagram.index).to include(:test)
    end
  end

end
