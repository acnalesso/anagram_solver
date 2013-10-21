require 'spec_helper'
require 'anagram_solver/middleware'

describe AnagramSolver::Middleware do
  let(:ted) { double("Ted") }
  let(:waremiddle) { AnagramSolver::Middleware.new(ted) }

  context "Middleware" do
    it "must respond_to :call" do
      waremiddle.should respond_to :call
    end

    it "must respond_to :app" do
      waremiddle.should respond_to :app
    end

    it "must initialize app instance var" do
      waremiddle.app.should_not be_nil
    end

    it "must call the next middleware" do
      ted.should_receive(:call).with(:next).
        and_return([])

      response = waremiddle.call(:next)
      response.should be_an Array
    end
  end
end
