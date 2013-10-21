require 'spec_helper'
require 'support/routing_helper'
require 'anagram_solver/routing'

class Bob
  include AnagramSolver::Routing
  include AnagramSolver::RoutingHelper
end

describe AnagramSolver::Routing do

  let(:bob) { Bob.new }
  context "Mount engine" do

    before { bob.anagram_to_root_path! }

    it { bob.should respond_to :anagram_to_root_path! }

    it "must have AnagramSolver::Engine as engine to be mounted" do
      bob.engine_name.should eq(AnagramSolver::Engine)
    end

    it "must mount as_root" do
      bob.mounted_at.should eq("/")
    end
  end

  describe "Make it available in Mapper" do

    let(:mapper) { ActionDispatch::Routing::Mapper.new }
    it "must respond_to :anagram_to_root_path!" do
      mapper.should respond_to :anagram_to_root_path!
    end

  end
end
