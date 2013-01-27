$LOAD_PATH.unshift File.dirname(__FILE__)
module PieMan
	%w[open3 socket singleton open-uri cgi pathname yaml net/https timeout fileutils csv rexml/document].map{|s| require s}
	include REXML

  # Set and connect to the local database
  DB = Sequel.connect("sqlite://pie-man.db")

	# Load relevant plugins from here, make sure you add/un-add filters in filters.rb
	%w[markov urbandict lastfm user messages].map{|s| require "plugins/#{s}"}
	require 'helpers'
	require 'kit-bot'
	require 'filters'

	def self.willStartNow
		conf = YAML.load_file 'meta/config.yml'
		bot = KitBot.new(conf['network'], conf['port'], conf['channel'], conf['nick'], conf['name'])
		bot.run
		trap("INT"){ bot.quit }
	end
end

if __FILE__ == $0
  PieMan.willStartNow
end
