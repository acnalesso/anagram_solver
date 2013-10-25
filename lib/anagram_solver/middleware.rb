require 'rack/request'

##
# TODO:
# Break this down, as it is doing
# alot.
module AnagramSolver
  class Middleware
    attr_reader :app

    def initialize(app)
      @app = app
    end

    ##
    # Assigns env to @env to be used later on.
    # If PATH_INFO matches search, it then tries
    # to find anagrams. In not it goes down the stack.
    #
    def call(env)
      @env = env
      uploaded_tempfile?
      search? || app.call(env)
    end

    ##
    # Returns a response which is a JSON response
    # if search_path?
    #
    # When trying to find an anagram AnagramSolver::Finder
    # either returns the anagrams found for a particular word or
    # it returns a notice (i.e a message ) saying that No anagrams
    # was found for that particular word.
    #
    def search?
      return response if search_path?
    end

    private

      attr_reader :env

      ##
      # True is PATH_INFO matches search,
      # false otherwise.
      #
      def search_path?
        env["PATH_INFO"] =~ /search/
      end

      ##
      # Sets a 200 HTTP response code,
      # Sets Content-Type to JSON, and
      # returns anagrams_result.
      #
      def response
        [200, { "Content-Type" => "application/json" }, [anagrams_result].to_json]
      end


      ##
      # Returns results of anagrams.
      # If none is found it returns a notice
      # saying that no anagram was found.
      #
      def anagrams_result
        Finder.find_for(word, @permutator)
      end


      ##
      # Gets the json request sent to server
      # then parse it and get the raw word.
      #
      def word
        _word_ = JSON.parse(env["rack.input"].string)
        _word_["word"]
      end

      ##
      # Rack::Request rocks!!
      #
      def params
        Rack::Request.new(env)
      end

      ##
      # Gets the tempfile uploaded.
      # Rack::Request parses and extract params
      # from StringIO for us.
      #
      def tempfile
        params["new_anagram"]["dict"][:tempfile]
      end

      def uploaded_tempfile?
        permutator if (env["PATH_INFO"] == "/anagrams")
      end


      def permutator
        @permutator = Permutator.new(tempfile)
      end

  end
end
