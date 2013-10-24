module AnagramSolver
  class AsyncConsumner

    attr_reader :queue, :thread
    attr_reader :block, :mutex

    def initialize(queue=Queue.new, &block)
      @queue  = queue
      @thread = Thread.new { consume }
      @mutex  = Mutex.new
      @block  = block
      @lock   = true
    end

    ##
    # Consumes data from a queue.
    # NOTE: If I was to use a while loop
    # here, I'd have to find a way of stoping
    # the loop. A common way would be pushing
    # nil to queue and then it would exit.
    # However I'd have to be passing nil ATFT.
    # If I didn't pass nil it would raise:
    #   Failure/Error:
    #   (anonymous error class);
    #   No live threads left. Deadlock?
    # As there's nothing in queue.
    #
    # In Ruby you have a lot of different ways
    # to make the same thing.
    #
    # This implentation simply asks queue what it's
    # size is and then loops through it (i.e times)
    # and then I call queue.deq which stands for
    # deqeuing.
    #
    def consume
      (queue.size).times do
        mutex.synchronize {
          block.call(queue.deq)
          @lock = true
        }
      end
    end

    ##
    # Pushes args in to a queue.
    #
    def push(*args)
      queue.push(*args)
      mutex.synchronize { @lock = false }
    end

    ##
    # Waits for a thread to finish
    # returns nil if limit seconds have past.
    # or returns thread itself if thread was
    # finished  whithing limit seconds.
    #
    # If you call it without a limit second,
    # it will use 0 as default, therefore it
    # will not wait thread to finish, and it
    # will return nil.
    # (i.e Stops main thread ( current one )
    # and waits until the other thread is finished,
    # then passes execution to main thread again. )
    #
    def wait_thread_to_finish!(ttw=0)
      thread.join(ttw)
    end

    def finished?
      lock
    end

    private
      attr_reader :lock

  end
end
