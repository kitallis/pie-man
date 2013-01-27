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

        username = msg.match(/^:[^!]*/)
        hostname = msg.match(/!~(.*)\s[PRIVMSG]/)
        @query = username

        def say_to_nick(msg)
          say "PRIVMSG #{@query.to_s.delete(':!')} :#{msg}"
        end

        begin

        if msg.match(/PRIVMSG ##{@channel} :(.*)$/)
          content = $~[1]
          # ---------------------------
          # ---------------------------
          # The filters start from here
          # ---------------------------
          # ---------------------------
          if content.strip.match('pie-man[,:] (hi|hey|sup|yo)$')
            say_to_chan('sup')
          end

          if content.strip.match('pie-man[,:] (bye|ciao|chow)$')
            say_to_chan('See ya in another life, brotha')
          end

	  	    # Creates a random string using the Markov module.
          if content.strip.match('pie-man[,:] (random|randomize|speak|talk|Talk)$')
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
                  puts "k"
                  outputStr = redirect { eval(s) } # helpers.rb
                  evalput = outputStr.split("\n")
                  puts evalput
                  if evalput.size > 5
                    evalput.first(4).each { |x| say_to_chan(x) } # avoid flood
                  else
                    evalput.each { |x| say_to_chan(x) }
                  end
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

          # Store messages.
          if content.match('pie-man[,:]\s(-->|->|tell)\s(\w*)\s(.*)$')
            to = $2.strip
            from = @query.to_s.delete(':!')
            content = $3.strip

            unless (to.blank? || content.blank? || from.blank?)
              Message.leave!(:to => to, :from => from, :content => content)
              say_to_chan("ok #{from}, will tell #{to} that.")
            end
          end

          # Retrieve messages.
          if content.match('pie-man[,:] give')
            who = @query.to_s.delete(':!')

            messages = Message.give(:who => who)
            say_to_chan("no messages for you.") if messages.empty?
            messages.each { |message| say_to_chan(message) }
          end

          # Prints the environment time, user geolocations would be rad.
          if content.strip.match('pie-man[,:] (thetime|time|date|TheTime|Time|Date)$')
            time = Time.now.utc
            say_to_chan(time.strftime("%d/%m/%Y %H:%M:%S").to_s + ' UTC')
          end

          if content.match("^##{@nick}[:,]").nil?
            File.open('meta/random.txt', 'a') do |f2|
              f2.write content.gsub(/\n/, ' ')
            end
          end

          if content.strip.match('pie-man[,:] ud (.+)')
            defin = Urban.define($1)[:defintions].to_a.flatten
            unless defin.empty?
              say_to_chan("%s: %s" % [defin[0], defin[1]])
            else
              say_to_chan("no definitions found")
            end
          end

          if content.strip.match('pie-man[,:] (the help|thehelp)$')
            say_to_chan('bawg off you bastard')
            puts username
            File.open('meta/help.txt').each_line do |s|
              say_to_nick(s)
            end
          end
	        # ---------------------------
          # ---------------------------
          # The filters end here
          # ---------------------------
          # ---------------------------
        end

        rescue NameError => e
          say_to_chan("Plugin/module deprecated, #{e}")
        end
      end
    end
  end
end
