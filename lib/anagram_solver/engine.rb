require 'anagram_solver/middleware'

module AnagramSolver
  class Engine < ::Rails::Engine
    isolate_namespace AnagramSolver

    initializer "anagram_solver.add_middleware" do |app|
      app.middleware.use AnagramSolver::Middleware
    end
  end
end
