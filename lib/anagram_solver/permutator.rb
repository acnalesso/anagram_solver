# encoding: utf-8
##
# Responsability
# Create a hash of precomputed anagrams
# to facilitate when searching for one.
# Rather than doing all the possible combinations
# at run time.
#
# Here's a benchmark with, unpack and chars
#
# require 'benchmark'
#
# Benchmark.bm do |bm|
#   bm.report("Unpack") do
#     1000_000.times do
#       "aabcjksjdsodoiio32j3k2jkjdksjkdsj,, ,fd,f,d, f,d,,---".gsub(/[,\t\r\n\f]*/, "").unpack("c*").sort.pack("c*")
#     end
#   end
#
#   bm.report("Chars") do
#     1000_000.times do
#       "aabcjksjdsodoiio32j3k2jkjdksjkdsj,, ,fd,f,d, f,d,,---".gsub(/[,\t\r\n\f]*/, "").chars.sort.join
#     end
#   end
# end
#
# user     system      total        real
# Unpack 37.620000   0.080000  37.700000 ( 37.781407)
# Chars 65.020000   0.200000  65.220000 ( 65.300449)
#

module AnagramSolver
  require 'anagram_solver/async_consumer'
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
    def precompute
      word_list.each do |line|
        word = line.slice(/\b['\wÀ-ÖÙ-Üà-öù-ü]+/i)
        precomputed_list[sort!(word)] += [word]
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
