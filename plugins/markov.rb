module PieMan
  class Markov
    def initialize(file)
      @text = Hash.new
      read_text(file)
    end

    def create_paragraph(len)
      scan = Array.new(2,"\n")
      @words = Array.new 

      flag = 0
      while @words.length <= len || flag == 0
        flag = 0
        word = random_word(scan)
        break if word == "\n"
        flag = 1 if word =~ /[\.\?\!][\"\(\)]?$/;
        @words.push(word) if @words.length > 0 || flag == 1
        scan.push(word).shift
      end
      
      @words.shift
    end
  
    def print_text
      @words.join(" ").gsub(/[\"\(\)]/,"").wordwrap(68)
    end
  
    private
    
    def read_text(file)
      File.open(file) do |f|
        scan = Array.new(2,"\n")
        while line = f.gets
          line.split.each do |w|
            add_text(scan[0], scan[1], w)
            scan.push(w).shift
          end
        end
 
      add_text(scan[0],scan[1], "\n")
      end
    end
  
    def random_word(scan)
      index = rand(@text[scan[0]][scan[1]].length)
      @text[scan[0]][scan[1]][index]
    end
  
    def add_text(a,b,c)
      if @text.key?(a)
        if @text[a].key?(b)
          @text[a][b].push(c)
        else
          @text[a][b] = Array.new(1,c)
        end
      else
        @text[a] = Hash.new
        @text[a][b] = Array.new(1,c)
      end
    end
  end
end
