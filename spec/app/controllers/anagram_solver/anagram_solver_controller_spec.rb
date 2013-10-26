require 'spec_helper'
require 'controllers/anagram_solver/anagram_solver_controller'

describe AnagramSolver::AnagramSolverController do

  let(:anagram) { AnagramSolver::AnagramSolverController.new }

  before { anagram.index }

  it "must have index action" do
    anagram.should respond_to :index
  end

  it "must have create action" do
    anagram.should respond_to :create
  end

  describe "respond_to" do
    it { anagram.extensions.should include(:html) }

    it { anagram.extensions.should include(:json) }
  end

end
