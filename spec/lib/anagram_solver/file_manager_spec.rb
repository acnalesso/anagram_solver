require 'spec_helper'
require 'anagram_solver/file_manager'
require 'tempfile'

module Rails
  def self.root; self end

  def self.join(*dirs)
    dirs[0] + dirs[1]
  end
end

module AnagramSolver
  RootPath = File.expand_path('../../../tmp/public/uploads', __FILE__)

  FileManager.class_eval do
    public(:file_name)
  end
end

describe AnagramSolver::FileManager do

  ##
  # Deletes all created files
  # NOTE: This will not work on Windows!!!
  #
  after(:all) do
    system("rm -r #{AnagramSolver::RootPath}/**")
  end

  let(:fixed_list) do
    # Creates a tmp file in /tmp dir
    # and writes to it.
    Tempfile.open("fixed_list") { |f|
      f.write("pots\nnots\nstop\nopts")
      f
    }
  end

  let(:pepper) { AnagramSolver::FileManager.new(fixed_list) }

  it "must have a root_path to save files" do
    pepper.root_path.should match /public\/uploads/
  end

  it "must keep track of current file path" do
    pepper.current_file_path.should match /fixed_list/
  end

  it "must know its file_name" do
    pepper.file_name.should match /fixed_list/
  end

  it "must read_lines from temp file" do
    pepper.read_lines.should match /opts/
  end

  it "must chec existence of current_file_path" do
    pepper.file_exist?.should be_true
  end

  it "must check existence of a file" do
    tmp_file = Tempfile.new("testing_existence")
    pepper.file_exist?(tmp_file).should be_true
  end

  context "Creating" do
    it "must create a new file based on temp_file" do
      pepper.new_file("pots\nnots\nopts\nstop")
      pepper.file_exist?.should be_true
    end

    context "Created file" do

      let(:bob) { pepper.new_file("different_name","test\nehere") }

      it "must exist" do
        pepper.file_exist?(bob.path).should be_true
      end

      it "must return created file" do
        bob.should be_a File
      end

      it "must be closed" do
        bob.closed?.should be_true
      end
    end
  end
end
