module PieMan
  class LastDotFM
    attr_reader :url, :xml_data, :doc
    def initialize(user, method)
      @user = user
      @method = method
      @cnf = YAML.load_file 'meta/lfm.yml'
      @url = "http://ws.audioscrobbler.com/2.0/?method=user.#{@method}&user=#{@user}&api_key=#{@cnf['LAST_FM_KEY']}"
      @xml_data = Net::HTTP.get_response(URI.parse(@url)).body
      @doc = REXML::Document.new(xml_data)
      @artist = []
      @track = []
      @date = []
      loadData
    end
     
    def getLastTrack
     if @track
      ["#{@track[0]}", "#{@artist[0]}", "#{@date[0]}"]
     end
    end

    def loadData
      if @method == "getrecenttracks"
        getRecentTracks
        getRecentArtists
        getTrackDates
      end
    end
    
    def getRecentTracks
      doc.elements.each('lfm/recenttracks/track/name') { |n|  
        @track << n.text 
      }
    end
   
    def getRecentArtists
      doc.elements.each('lfm/recenttracks/track/artist') { |a|  
        @artist << a.text 
      }     
    end
  
    def getTrackDates
      doc.elements.each('lfm/recenttracks/track/date') { |d|  
        @date << d.text 
      }     
    end   
  end
end
