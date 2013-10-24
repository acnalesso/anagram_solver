require 'spec_helper'
require 'anagram_solver/async_consumer'

describe AnagramSolver::AsyncConsumer do
  let(:alien) { AnagramSolver::AsyncConsumer.new }

  context "Block" do
    let(:bob) do
      AnagramSolver::AsyncConsumer.
        new { |hiya| hiya }
    end

    it { bob.should respond_to :block }

    it { bob.block.should respond_to :call }

    it "must yield content of block" do
      bob.block.call(:hiya).should eq(:hiya)
    end
  end

  context "Queue" do
    it { alien.should respond_to :queue }
    it { alien.queue.should be_a Queue }

    it "must push contents to queue" do
      alien.push("Test")
      alien.queue.shift.should eq("Test")
    end
  end

  context "Thread" do
    it { alien.should respond_to :thread }

    it { alien.thread.should respond_to :join }

    it { alien.thread.alive?.should be_true }

    ##
    # NOTE:
    # Thread#join returns nil if limit seconds have past
    # in this case the thread is spleeping for 0.0001 and
    # we're not waiting at all. Therefore it returns nil
    #
    it "must wait until thread is finished" do
      alien.stub(:thread).
        and_return(Thread.new { sleep 0.0001 })
      alien.wait_thread_to_finish!.should eq(nil)
    end

    it "must accecpt time to wait" do
      alien.stub(:thread).
        and_return(Thread.new { :im_finished! })
      alien.wait_thread_to_finish!(0.002).should eq(alien.thread)
    end
  end

  context "Mutex" do
    it { should respond_to :mutex }

    it { alien.mutex.should be_a Mutex }

    it { alien.mutex.should respond_to :synchronize }
  end

  context "Consumering" do

    ##
    # NOTE:
    # I could've used rspec stub, and stubed
    # out #block, or even passed it in while
    # initialising the object, but I wanted
    # to play around with ruby.
    #
    it "must consume data in queue" do
      me = ->(*args) { }
      pet = AnagramSolver::AsyncConsumer.new(&me)
      pet.push [ :test ]
      pet.consume
      pet.queue.size.should eq 0
    end

    it "must call the block passed" do
      suze   = double
      suze.should_receive(:call).with(:hi)

      frankie = AnagramSolver::AsyncConsumer.new
      frankie.stub(:block).and_return(suze)

      frankie.push :hi
      frankie.consume
    end

  end

  context "AsyncConsumer" do
    ##
    # NOTE: Fila means queue in PT-BR
    #
    it "must be working" do
      angelina = double
      angelina.should_receive(:jolie).
        with(:my_number)

      fila = Queue.new
      fila << angelina

      sun = AnagramSolver::AsyncConsumer.
        new(fila) do |angelina|
          angelina.jolie(:my_number)
        end
      ##
      # NOTE: Here we need to wait for the thr
      # to finish, otherwise rspec mock would not
      # work, as it would receive the message in
      # a later time.
      #
      sun.wait_thread_to_finish!(4)
      sun.queue.size.should eq(0)
    end
  end

  describe "Avoiding Race condition" do

    context "Lock","with Mutex" do

      let(:lion) { AnagramSolver::AsyncConsumer.new }
      it { should respond_to :finished? }

      it "must be finished when initialised" do
        lion.finished?.should be_true
      end

      it "must not be finished while pushing to queue" do
        lion.push(:im_going)
        lion.finished?.should be_false
      end

      describe "while consuming" do

        it "must be set automaticaly based on queue's size" do
          kcolb = ->(args) { args }
          cat = AnagramSolver::AsyncConsumer.new(&kcolb)
          cat.push(:me_too)
          cat.wait_thread_to_finish!(1)
          cat.finished?.should be_true
        end

      end # end of while consuming

    end

    describe "Background Processsing" do
      let(:caw) { AnagramSolver::AsyncConsumer }

      it { caw.should respond_to :bg_process }

      it "must not block IO" do
        call_me = double
        call_me.should_receive(:call)
        caw.bg_process( call_me ) { |c| c.call(:been_called) }
        caw.wait
      end
    end

  end

end
