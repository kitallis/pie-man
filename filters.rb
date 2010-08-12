module PieMan
  class KitBot
    def run
      until @socket.eof? do
        msg = @socket.gets
        puts msg
        
        if msg.match(/^PING :(.*)$/)
          say "PONG #{$~[1]}"
          next
        end
        
        username = msg.match(/:(.*)!/)
        hostname = msg.match(/!~(.*)\s[PRIVMSG]/)
        @query = username
	
        def say_to_nick(msg)
          say "PRIVMSG #{@caller.to_s.delete(':!')} :#{msg}"
        end
	
        begin; if msg.match(/PRIVMSG ##{@channel} :(.*)$/)
          content = $~[1]
          # ---------------------------
          # ---------------------------
          # The filters start from here
          # ---------------------------
          # ---------------------------
          if content.match('pie-man[,:] (hi|hey|sup|yo)')
            say_to_chan('sup ' + username.to_s.delete(':'))
          end
          
          if content.match('pie-man[,:] (bye|ciao|chow)')
            say_to_chan(username.to_s.delete(':!') + ', See ya in another life, brotha')
          end

	  	    # Creates a random string using the Markov module.
	  	    if content.match('pie-man[,:] (random|randomize|speak|talk|Talk)')
            text = Markov.new('meta/random.txt')
            text.create_paragraph(1)
            say_to_chan(text.print_text.to_s.strip.delete("[]","()", ":").gsub(/\n/, '. '))
            next
          end

          # Last.fm 'now playing' module.
	  	    if content.strip.match('pie-man[,:] \bnp\s+([\w-]*)$') # notice the strip
            user = $1
            lfm = LastDotFM.new(user, 'getrecenttracks').getLastTrack
            puts "caught " + user
            if lfm == ["","",""] or lfm.nil? or lfm.empty?
              say_to_chan('bhut user? lol gtfo') 
            else 
              say_to_chan("#{user} recently listened to #{lfm[0]} by #{lfm[1]}")
            end
          end

          # ruby eval module.
	  	    if content.match('pie-man[,:] \brb\s+(.*)')
            s = $1
            Thread.new do
              begin
                timeout(5) do
                  $SAFE = 2
                  s.untaint
                  outputStr = redirect { eval(s) } # helpers.rb
                  outputStr.split("\n").each { |x| say_to_chan(x) }
                end
              rescue SecurityError
                say_to_chan ("SECURITY BREACH.")
              rescue Timeout::Error
                say_to_chan ("Timed out, nub :/")
              rescue Exception => e
                say_to_chan ("Error, #{e}")
              end
            end
          end

          # Karma module.
	        if content.match('pie-man[,:] karma (.*)')
            s = $1.strip
            say_to_chan("#{s}'s karma is #{Karma.new.read(s)}")
          end
          
          if content.strip.match('(pie-man[:,])?(.*?)(\+\+|--)$')
            Karma.new.write($2.strip, $3.strip, hostname)
          end

          # Pushes out the environment time, user geolocations would be rad.
          if content.match('pie-man[,:] (thetime|time|date|TheTime|Time|Date)')
            time = Time.now
            say_to_chan(time.strftime("%d/%m/%Y %H:%M:%S").to_s + ' IST')
          end
          
          if content.match("^##{@nick}[:,]").nil?
            File.open('meta/random.txt', 'a') do |f2|
              f2.write content.gsub(/\n/, ' ')
            end
          end

	        if content.match('pie-man[,:] (help)')
            say_to_chan('fuck you')
            File.open('meta/help.txt').each_line do |s|
            say_to_nick(s)
            end
          end
	        # ---------------------------
          # ---------------------------
          # The filters end here
          # ---------------------------
          # ---------------------------
        end; rescue NameError => e
          say_to_chan("Plugin/module deprecated, #{e}"); end  
      end
    end
  end
end
