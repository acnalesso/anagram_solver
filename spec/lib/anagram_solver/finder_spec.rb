require 'spec_helper'
require 'anagram_solver/finder'

describe AnagramSolver::Finder do
  let(:finder) { AnagramSolver::Finder }
  let(:list) { double }

  before do
    fake_json_list = { "test" =>  [ "estt" ] }
    list.stub(:sort!).and_return("test")
    list.stub(:precomputed_list).and_return(fake_json_list)
  end

  it "must find one anagram" do
    expect(finder.find_for("test", list)).
    to match(/1 anagram found for 'test' in/)
  end

  it "must find 2 anagrams" do
    anagrams = Hash.new([ "estt", "tets" ])
    list.stub(:precomputed_list).and_return(anagrams)
    expect(finder.find_for("test", list)).
    to match(/2 anagrams found for 'test' in/)

  end

  it "must not found anagram" do
    hash = Hash.new([])
    list.stub(:precomputed_list).and_return(hash)

    expect(finder.find_for("test", list)).
    to match(/0 anagrams found for 'test'/)
  end

end
