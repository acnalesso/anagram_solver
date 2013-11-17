module AnagramSolver
  class Anagram
    include Mongoid::Document

    field :searched_at, type: Date
    field :finished_at, type: Date
    field :dictionary_name, type: String
  end
end
