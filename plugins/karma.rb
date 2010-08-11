module PieMan
  class Karma
	  attr_reader :rows
	  attr_accessor :db
	
	  def initialize()
		  @rows = []
		  @db = SQLite3::Database.new("pie-man.db")
	  end
	  
    def read(object)
		  begin
			  Hash[*grab.flatten].fetch(object)
		  rescue KeyError
			  0
		  end
	  end
			
	  def write(object, karma, hostname)
		  unless object.nil? or object.empty? or host?(hostname)
			  objVal = read(object).to_i
			  karma == "++" ? objVal += 1 : objVal -= 1
			  @db.execute("insert or replace into karma values ('#{object}', '#{objVal}', '#{hostname}');")
		  end
	  end
	
	  private
	
		def grab
			rows = @db.execute("select name, karma from karma")
		end

		def hosts
			hosts = @db.execute("select host from karma")
		end
	
		def host?(h)
			(hosts.flatten).select{|v| v =~ /#{h}/ }.empty?
		end
  end
end
=begin
class Karma


	attr_reader :rows
	def initialize()
		@rows = []

	end
  
  def grab
  	Excelsior::Reader.rows(File.open('karma.csv', 'rb')) do |row|

 			rows << row
		end
		rows
	end

  	
	def read
		begin
			Hash[*grab.flatten] 

		rescue KeyError => e
			0
		end
	end


	def write(object, karma)
		unless object.nil? or object.empty?
			objVal = read.fetch(object).to_i
			fileObj = File.new("karma.csv")

			karma == "++" ? objVal += 1 : objVal -= 1

			if read.fetch(object).to_i
				line_arr = File.readlines("karma.csv")
  			lines_to_delete.each do |index|
    			line_arr.delete_at(index)
  			end 
  			File.open(filename, "w") do |f| 
    			line_arr.each{|line| f.puts(line)}
  			end
			else
				File.open("karma.csv", "a") do |csv|
     			csv << "#{object},#{objVal.to_s}\n"
     		end
   		end
   		
		end
		
	end
	
end
=end






