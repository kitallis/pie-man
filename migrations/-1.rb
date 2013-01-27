require 'rubygems'
require 'sequel'

DB = Sequel.connect("sqlite://pie-man.db")

puts "* Removing the User table..."
DB.drop_table :users
puts "* Removed."

DB.disconnect
