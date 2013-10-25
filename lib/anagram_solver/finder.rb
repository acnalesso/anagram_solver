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
      def find_for(key, list)
        timer { look_up(list, key) }
        anagrams_found!
      end

      ##
      # Look for anagrams
      #
      def look_up(list, key)
        @key      = list.sort!(key.chomp)
        @anagrams = list.precomputed_list[@key]
      end

      private

      ##
      # Generates a JSON object
      # with results of finished_at, started_at,
      # milliseconds, and anagrams found.
      def anagrams_found!
        {
          notice: "#{size} anagrams found for '#{@key}'",
          anagrams: join_anagrams_found!,
          time: @time.to_s[0],
          finished_at: normalize_time!(@finished_at),
          started_at: normalize_time!(@started_at)
        }.to_json
      end

      def size
        @anagrams.size
      end

      def join_anagrams_found!
        @anagrams.join(", ")
      end


      ##
      # Simple timer to get started/finished time/date
      # and to generate milliseconds
      def timer
        @started_at = Time.now
          result = yield
        @finished_at = Time.now
          result
        ensure
        @time = (@finished_at - @started_at) * 1000
      end

      ##
      # Normalizes time as 10/25/2013 at 04:15 PM
      #
      def normalize_time!(time)
        time.strftime("%m/%d/%Y at %I:%M %p")
      end

      ##
      # Get milliseconds.
      #
      def milliseconds
        @finished_at.strftime("%N").to_i - @started_at.strftime("%N").to_i
      end

    end


  end
end
