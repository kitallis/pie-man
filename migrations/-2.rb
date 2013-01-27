require 'rubygems'
require 'sequel'

DB = Sequel.connect("sqlite://pie-man.db")

puts "* Removing the Message table..."
DB.drop_table :messages
puts "* Removed."

DB.disconnect
