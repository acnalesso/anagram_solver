##
# Responsability
# Add anagram_solver as root_path
#
# TODO:
# Allow anagram_solver to be mounted
# at a different path.
module AnagramSolver
  module Routing
    extend ActiveSupport::Concern 
    def anagram_to_root_path!
      mount(AnagramSolver::Engine, at: "/")
    end

  end
end

ActionDispatch::Routing::Mapper.send(:include, AnagramSolver::Routing)
