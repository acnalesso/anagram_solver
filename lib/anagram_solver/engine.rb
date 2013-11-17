module AnagramSolver
  class Engine < ::Rails::Engine
    isolate_namespace AnagramSolver

    initializer "anagram_solver.add_middleware" do |app|
      app.middleware.insert_after ::Rack::Runtime, AnagramSolver::Middleware
    end

  end
end
