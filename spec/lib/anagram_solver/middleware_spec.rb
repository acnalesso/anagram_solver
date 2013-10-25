require 'spec_helper'
require 'json'
require 'stringio'
require 'rack/mock'
require 'anagram_solver/middleware'

module AnagramSolver
  Middleware.class_eval do
    public( :word, :params, :tempfile,
            :uploaded_tempfile?, :permutator )
  end

  class Finder
  end

  class Permutator
    def initialize(words)
      words
    end
  end
end

describe AnagramSolver::Middleware do
  let(:env) do
    {
      "PATH_INFO" => "/anagrams_search",
      "rack.input" => StringIO.new('{ "word": "test"}'),
      "new_anagram" => { "dict" => { tempfile: "text.txt" } }
    }
  end

  let(:ted) { double("Ted") }
  let(:waremiddle) { AnagramSolver::Middleware.new(ted) }
  let(:app) { ->(*args) { args } }
  let(:rack) { AnagramSolver::Middleware.new(app) }

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

    context "Uploading a file","Permutator" do

      before {
        env["PATH_INFO"] = "/anagrams"
        rack.stub(:env).and_return(env)
        rack.stub(:params).and_return(env)
      }

      it { rack.should respond_to :permutator }

      it { rack.permutator.should be_kind_of AnagramSolver::Permutator }

      it {
        rack.call(env)
        rack.instance_variable_get(:@permutator).should_not be_nil
      }

      it { rack.should respond_to :params }
      it { rack.should respond_to :tempfile }
      
      it {
        rack.tempfile.should eq("text.txt")
      }

      it { rack.should respond_to :uploaded_tempfile? }

      it "must parse PATH_INFO to see if a file is being uploaded" do
        rack.uploaded_tempfile?.should be_true
      end

      it "must send tempfile to AnagramSolver::Permutator" do
        AnagramSolver::Permutator.stub(:new).with("text.txt")

        rack.call(env)
        AnagramSolver::Permutator.should have_received(:new)
      end

      it "must go down the stack" do
        arnold = double
        arnold.should_receive(:call).with(env)
        rack.stub(:app).and_return(arnold) 

        rack.call(env)
      end
    end

    context "Anagrams" do
      let(:tob) { AnagramSolver::Middleware.new env }

      it "must get word to find anagrams for" do
        tob.stub(:env).and_return(env)
        tob.word.should eq("test")
      end
    end

    describe "/search" do

      let(:tim) { AnagramSolver::Middleware.new env }

      before do
        tim.stub(:env).and_return(env)
        tim.should_not_receive(:call).with(env)
      end

      it "must search if search_path?" do
        r = [200, { "Content-Type" => "application/json" }, ["opts"].to_json]

        tim.stub(:anagrams_result).and_return("opts")
        tim.search?.should eq(r)
      end

      context "Anagram found" do

        let(:vendetta) { double }
        let(:mid) { AnagramSolver::Middleware.new(vendetta) }

        it "must not call the next middleware" do
          AnagramSolver::Finder.stub(:find_for)
          mid.stub(:params).and_return(env)
          vendetta.should_not_receive(:call)
          mid.call(env)
        end

      end

      context "Anagram not found" do

        it "must return a notice" do
          notice = "No anagrams found for :word"
          AnagramSolver::Finder.stub(:find_for).and_return(notice)
          r = [200, { "Content-Type" => "application/json" }, [notice].to_json]

          tim.search?.should eq(r)
        end
      end
    end

  end
end
