# encoding: utf-8
#
# Responsability
# Create a hash of precomputed anagrams
# to facilitate when searching for one.
# Rather than doing all the possible combinations
# at run time.
#
# See ./benchmark/permutator for more info.

require 'anagram_solver/async_consumer'
module AnagramSolver

  class Permutator

    attr_reader :word_list, :precomputed_list
    attr_reader :precomputed_list_old, :bg_process

    ##
    # Initializes word_list instance variable, precomputed_list
    # assigning it a hash whose default values is an empty array.
    #
    # Precomputes word_list in underneath the hood. (i.e A in-process
    # thread that AsyncConsumer offers. )
    #
    def initialize(word_list)
      @word_list        = word_list
      @precomputed_list = Hash.new([])
      @bg_process       = AsyncConsumer.bg_process(self) { |s| s.precompute }
      @precomputed_list_old = Hash.new([])
    end

    ##
    # Used for benchmarking
    #
    def precompute_old
      warn "This method should not be used, please use precompute instead."
      word_list.rewind.each do |line|
        word = line.chomp
        precomputed_list_old[word.split('').sort.join.freeze] += [word]
      end
    end

    ##
    # Generates a hash whose keys are sorted
    # alphabetically and values (i.e rhd ) are words
    # in its normal order.
    #
    # Given a list pots, stop, opts
    # When I precompute it
    # Then I should have a hash like:
    # { "opst" => [ "pots", "stop", "opts" ] }
    #
    # NOTE:
    # precompute only gets the first word it 'slices' off
    # a line. Therefore if a line was:
    # "pots, opts"
    # It would get the first word, which is +pots+.
    #
    # However if it was:
    # ", Deviation's, pots";
    # It would slice Deviation's
    #
    # It is also slices words with accents, such as:
    # émigré's
    # Ångström
    #
    # If you're on UNIX-like there might exist a dict
    # word in see /usr/share/dict/words
    #
    # Want to learn more about Regexp?
    # Fear not:
    # open-std.org/jtc1/sc22/wg21/docs/papers/2003/n1500.html
    #
    # This snippet here looks a bit odd, let dissect it.
    # line = "Hello there"
    #
    # This is the same as line =~ /\S+/, However Ruby 1.9 >
    # provides this awesome way to do it.
    # line[/\S+/]
    #
    # Then $~[0] gets the first argument matched, which
    # here is Hello.
    #
    # This is incredibily fast, please see benchmark
    # ./benchmark/permutator.rb
    #
    def precompute
      word_list.each do |line|
        precomputed_list[sort!(line[/\S+/])] += [$~[0]]
      end
    end

    ##
    # Orders any given word in alphabetical order by
    # unpacking them (i.e spliting ) sort and packing
    # them again ( i.e joining ).
    # This facilitates when trying to find combinations
    # for words, as we only have to sort once
    # and return results by calling a hash with a sorted key.
    #
    # ruby-doc.org/core-2.0.0/Array.html#method-i-pack
    # See: en.wikipedia.org/wiki/UTF-8
    # Unpacks a string using:
    # Integer UTF-8 character, as it can represent
    # every character in the Unicode char set.
    # Such as émigré's
    # * means all remaining arrays elements will be
    # converted.
    #
    # Freezes string, otherwise Ruby would generate
    # another String object instead of keeping
    # the one already supplied. So that we would have
    # two instances of the same thing in memory.
    #
    def sort!(word)
      word.unpack("U*").sort.pack("U*").freeze
    end

  end
end
