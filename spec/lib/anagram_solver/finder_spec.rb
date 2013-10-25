require 'spec_helper'
require 'anagram_solver/finder'

describe AnagramSolver::Finder do
  let(:finder) { AnagramSolver::Finder }
  let(:ed) { double }
  before do
    fake_list = { "test" =>  [ "estt" ] }
    ed.stub(:sort!).and_return("test")
    ed.stub(:precomputed_list).and_return(fake_list)
  end

  it "anagram_found" do
    expect(finder.find_for("test", ed)).
    to match(/1 anagrams found for 'test'/)
  end

  it "anagram_not_found" do
    hash = Hash.new([])
    ed.stub(:precomputed_list).and_return(hash)
    expect(finder.find_for("test", ed)).
    to match(/0 anagrams found for 'test'/)
  end

end
