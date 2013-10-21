require 'spec_helper'

describe "Ensure AnagramSolver::Middleware is in use" do
  it "must have anagram_solver's middleware in stack" do
    Rails.application.middleware.should include(AnagramSolver::Middleware)
  end
end
