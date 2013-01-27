require 'rubygems'
require 'sequel'

DB = Sequel.connect("sqlite://pie-man.db")

puts "* Removing the Karma table..."
DB.drop_table :karma
puts "* Removed."

DB.disconnect
