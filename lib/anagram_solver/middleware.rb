module AnagramSolver
  class Middleware
    attr_reader :app

    def initialize(app)
      @app = app
    end

    def call(env)
      words = Hash.new([])
      file = env["rack.request.form_hash"]["post"]["file_name"]

      file[:tempfile].open.readline do |line|
        w = line.chomp
        words[w.split('').sort!.join('')] += [w]
      end

      File.open(Rails.root.join('public','uploads',file[:file_name]),'w') do |f|
        Marshal.dump(words, f)
      end

      app.call(env)
    end

  end
end
