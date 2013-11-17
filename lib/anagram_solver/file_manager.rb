##
# Responsability
# Read lines from a file
# Create a new file, absolute path should be passed in.
# Check file exists?
# Manage a File object
#
# TODO:
# Make it compartible with File object
# As it is only compartible with Tempfile
#
module AnagramSolver
  class FileManager
    attr_reader :current_file, :root_path

    ##
    # current_file is a temp_file to read
    # content from it and be destroyed later on when
    # everything gets garbaged.
    #
    # root_path is the path to save new files.
    #
    # TODO:
    # Make it work with instances of File,
    # as it only works with Tempfile.
    #
    def initialize(current_file)
      @current_file = current_file
      @root_path    = AnagramSolver::RootPath
    end

    def read_lines
      open_safely! { |f| f.rewind; f.read }
    end

    ##
    # Returns file's root path
    #
    def current_file_path
      current_file.to_path
    end

    ##
    # Creates a new file, saves it based on
    # root_path provided.
    # NOTE: Ruby File#open when called with a block closes
    # file stream for us.
    # This is not compartible with Ruby 1.8.7.
    #
    def new_file(new_name=false, body)
      f_name = new_name || file_name_with_path
      File.open(f_name, "w") { |line|
        line.write(body)
        line
      }
    end

    ##
    # Checks file existence using current_file_path.
    # However if absolute path is passed in, uses this
    # over current_file_path.
    #
    def file_exist?(_file_name_=false)
      File.exists?(_file_name_ || current_file_path)
    end


    private

      ##
      # Keeps a tmp_file opened for the
      # duration of a block call.
      #
      def open_safely!
        yield current_file.open
        ensure
        current_file.close
      end

      ##
      # Creates a root_path with file name at the end.
      #
      def file_name_with_path
        root_path.dup + file_name
      end

      ##
      # Returns its random file name that TempFile
      # assings when new object is created.
      # test_file_name434302324843493
      #
      def file_name
        "/" + current_file.path.split('/').pop
      end

  end
end
