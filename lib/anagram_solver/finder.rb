require 'json'
##
# TODO:
# This object is doing too much
# Perhaps we need to break it into
# smaller objects.
#
module AnagramSolver
  class Finder

    class << self

      include ActionView::Helpers::TextHelper

      attr_accessor :finished_at, :started_at
      attr_accessor :time, :word, :anagrams
      @finished_at  = ""
      @started_at   = ""
      @time         = ""
      @word         = ""
      @anagrams     = ""

      ##
      # Finds anagrams for a given key ( i.e word )
      # and a list, which should be already precomputed.
      # It returns a JSON object, see anagrams_found!.
      #
      def find_for(key, list)
        timer { look_up(list, key) }
        anagrams_found!
      end

      ##
      # Look for anagrams
      #
      def look_up(list, _word_)
        @word       = _word_
        key         = list.sort!(word)
        @anagrams   = list.precomputed_list[key]
      end

      private

      ##
      # Generates a JSON object
      # with results of finished_at, started_at,
      # milliseconds, and anagrams found.
      def anagrams_found!
        {
          notice: "#{pluralize(size, "anagram")} found for '#{word}' in #{time}",
          anagrams: join_anagrams_found!,
          finished_at: normalize_time!(finished_at),
          started_at: normalize_time!(started_at)
        }.to_json
      end

      def size
        anagrams.size
      end

      def join_anagrams_found!
        anagrams.join(", ")
      end

      ##
      # Simple timer to get started/finished time/date
      # and to generate milliseconds
      #
      def timer
        self.started_at   = Time.now
          result = yield
        self.finished_at  = Time.now
          result
        self.time = (self.finished_at - self.started_at) * 1000
      end

      ##
      # Normalizes time as 10/25/2013 at 04:15 PM
      #
      def normalize_time!(_time_)
        _time_.strftime("%m/%d/%Y at %I:%M %p")
      end

      ##
      # Get milliseconds.
      #
      def milliseconds
        finished_at.strftime("%N").to_i - started_at.strftime("%N").to_i
      end

    end


  end
end
