require 'spec_helper'
require 'anagram_solver/permutator'

AnagramSolver::Permutator.class_eval do
end

describe AnagramSolver::Permutator do
  let(:jolie) { IO.foreach(File.expand_path("../../../support/fixed_list", __FILE__)) }
  let(:steve) { AnagramSolver::Permutator.new jolie }

  before { steve.bg_process.join(2) }

  it "must keep track of word_list" do
    steve.should respond_to :word_list
  end

  it "must sort! a given word" do
    steve.sort!("dcba").should eq("abcd")
  end

  it "must keep track of precomputed_list" do
    steve.should respond_to :precomputed_list
    steve.precomputed_list.should be_a Hash
  end

  it "must precompute a list of words" do
    steve.precomputed_list["opst"].should have(5).words
    steve.precomputed_list["estt"].should have(1).words
  end

  it "must slice words with accent" do
    rose = AnagramSolver::Permutator.new %w{ igré'sém émgréi's Ånöm éigmré's}
    rose.bg_process.join(2)

    key = rose.sort!("émigré's")
    rose.precomputed_list[key].should have(3).words
    puts rose.precomputed_list
  end

end
