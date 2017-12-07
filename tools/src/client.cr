require "http/client"
require "option_parser"

class Client
  def initialize
    @threads  = 16
    @clients  = 10
    @requests = 100

    OptionParser.parse! do |parser|
      parser.banner = "Usage: time ./bin/benchmark [options]"
      parser.on("-t THREADS", "--threads=THREADS", "# of threads") do |threads|
        @threads = threads.to_i
      end
      parser.on("-c CLIENTS", "--clients=CLIENTS", "# of clients sending the requests") do |clients|
        @clients = clients.to_i
      end
      parser.on("-r REQUESTS", "--requests=REQUESTS", "# of iterations of requests") do |requests|
        @requests = requests.to_i
      end
    end
  end

  macro run_spawn
    spawn do
      @clients.times do |cl|
        c = HTTP::Client.new "localhost", 3000
        @requests.times do |t|
          r = c.get  "/"
          abort "status code should be 200 when GET /" if r.status_code != 200
          n = cl * @requests + t
          r = c.get  "/user/#{n}"
          abort "status code should be 200 when GET /user/:id" if r.status_code != 200
          abort "body should be '#{n}'" if r.body.lines.first !=n.to_s
          r = c.post "/user"
          abort "status code should be 200 when POST /user" if r.status_code != 200
        end
        c.close
      end
      channel.send(nil)
    end
  end

  def run
    channel = Channel(Nil).new

    @threads.times do |t|
      run_spawn
    end

    @threads.times do |t|
      channel.receive
    end
  end
end

client = Client.new
client.run
