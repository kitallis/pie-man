require 'cgi'
require 'nokogiri'
require 'open-uri'


class Urban
  def self.define(term)
    url = "http://www.urbandictionary.com/define.php?term=%s" % CGI.escape(term)
    begin
      doc = Nokogiri::HTML(open(url))
    rescue OpenURI::HTTPError, Errno::ENOENT => err
      return {:error => true, :message => err.message}
    end
    
    out = {}
    
    count = doc.search("//td[@class='index']/a").map do
      |x| x.text.strip.chomp('.').to_i
    end.last
    
    if count.to_i < 1
      return {:error => true, :message => 'No results found'}
    end
    
    out[:count] = count
    
    definitions = {}
    
    words = doc.search("//td[@class='word']")
    words.each do |wq|
      word = wq.text.strip
      defin = wq.at("./following::tr/td[@class='text']/div[@class='definition']").text
      
      if definitions.key?(word)
        definitions[word] << defin
      else
        definitions[word] = [defin]
      end
    end
  
    out[:defintions] = definitions
    
    out
  end
end

#defi = Urban.define("George W. Bush")[:defintions].to_a.flatten
#puts "%s: %s" % [defi[0], defi[1]] 
