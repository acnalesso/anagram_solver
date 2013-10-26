AnagramSolver::Engine.routes.draw do
  root "anagram_solver#index"

  resource :anagram_solver, controller: :anagram_solver
end
