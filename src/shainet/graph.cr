require "kemal"

module SHAInet
  class Graph

    setter ready

    def initialize(@ch_ready : Channel(String) = ready)
      @ready = ""
      @visualiser = Visualizer.new("Batch learning Iris\n\n")
      @started = 0i64
      Kemal.config.logging = false
      Kemal.config.shutdown_message = false
      Kemal.config.env = "production"
      Kemal.config.public_folder = File.join(__DIR__, "..", "..", "public")
      init_routes
      update
    end

    def init_routes
      get "/" do |env|
        env.redirect "/index.html"
      end

      get "/test" do
        "test"
      end

      get "/isready" do |env|
        payload
      end
    end

    def log
      Kemal.config.logging = true
    end

    def start
      @started = now_msec
      Kemal.run
    end

    def payload
      if @ready.includes?("Epoch")
        "#{duration},#{@ready}"
      else
        "busy"
      end
    end

    def duration
      s = ((now_msec - @started) / 1000).to_i32
      sec = (min = s / 60) > 0 ? (s % 60) : s
      String.build do |str|
        str << "Time: "
        str << min
        str << (sec < 10 ? ":0" : ":")
        str << sec
      end
    end

    def now_msec
      Time.now.epoch_ms
    end

    def update
      spawn do
        loop do
          @ready = @ch_ready.receive
        end
      end
    end
  end
end
