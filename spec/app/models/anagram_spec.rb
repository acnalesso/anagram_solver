require 'spec_helper'
require 'active_support/concern'
require 'active_support/core_ext/array/extract_options'

module Mongoid
  module Document
    extend ActiveSupport::Concern

    module ClassMethods
      ##
      # Defines a method with a given name
      # whose its body is a hash of options
      # passed. see ActiveSupport's extract_options
      #
      def field(name,*opts)
        define_method(name) { opts.extract_options! }
      end
    end

    ##
    # Facilitate tests
    #
    def field_type(name)
      send(name)[:type]
    end

  end
end

require 'models/anagram_solver/anagram'

describe AnagramSolver::Anagram do

  let(:anagram) { AnagramSolver::Anagram.new }
  context "Fields" do
    it "must respond_to searched_at" do
      anagram.should respond_to :searched_at
    end

    it "must set searched_at to date type" do
      anagram.field_type(:searched_at).should eq(Date)
    end

    it "must respond_to finished_at" do
      anagram.should respond_to :finished_at
    end

    it "must set finished_at to Date type" do
      anagram.field_type(:finished_at).should eq(Date)
    end

    it "must save dictionary's name" do
      anagram.should respond_to :dictionary_name
    end

    it "must set dictionary_name to String type" do
      anagram.field_type(:dictionary_name).should eq(String)
    end

  end
end

