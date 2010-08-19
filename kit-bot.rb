module PieMan
	class KitBot
		attr_accessor :query
  	def initialize(server, port, channel, nick, name)
    	@channel = channel
    	@socket = TCPSocket.open(server, port)
    	@nick = nick
    	@name = name

    	say "NICK #{@nick}"
    	say "USER kit-bot 0 * kit-bot"
    	say "JOIN ##{@channel}"
    	say_to_chan "#{1.chr}ACTION does no wrong. #{1.chr}"
  	end

    def say(msg)
      puts msg
      @socket.puts msg
    end
  
    def say_to_chan(msg)
      say "PRIVMSG ##{@channel} :#{msg}"
    end
  
    def quit
      say "PART ##{@channel} :nub"
      say 'QUIT'
    end

  end
end
