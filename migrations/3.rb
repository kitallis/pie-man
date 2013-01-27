require 'rubygems'
require 'sequel'

DB = Sequel.connect("sqlite://pie-man.db")

puts "* Creating the Karma table..."
DB.create_table :karma do
  primary_key :id
  foreign_key :user_id, :users
  Integer     :value, :default => 0
  Time        :created_at, :default => Sequel::CURRENT_TIMESTAMP
end
puts "* Finished creating the Karma table."

puts "* Adding a dummy karma for the user 'pie-man'..."
karma = DB[:karma]
karma.insert(:user_id => 1,
      :value => 4815162342)
puts "* Finished adding the dummy karma."

DB.disconnect
