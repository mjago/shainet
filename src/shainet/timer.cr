module SHAInet
  struct Timer
    def initialize(delay = 0)
      @delay = delay < 1000 ? 1000 : delay
      @first_run = true
      @first_time = 0_i64
      @last_time = 0_i64
      @hits = 0
      @count = 0
    end

    def elapsed?(ref = :last)
      temp = Time.now.epoch_ms
      case ref
      when :first
        @hits += 1
        if @first_time == 0_i64
          @first_time = temp
        else
          if temp > @first_time + @delay.to_i64
            @last_time = temp
            @first_run = false
          end
        end
        true
      else
        if temp > @last_time + @delay.to_i64
          @last_time = temp
          true
        else
          false
        end
      end
    end

    def update? : Bool
      if @first_run
        elapsed? :first
      else
        @count += 1
        if @count > @hits
#          puts "@count #{@count}, @hits #{@hits}"
          unless elapsed?
            @hits += 1
            false
          else
            if (temp = ((@count - @hits) / 2)) > 1
              @hits = temp
            end
            @count = 0
            true
          end
        else
          false
        end
      end
    end
  end
end
