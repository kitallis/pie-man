require 'rubygems'
require 'sequel'

DB = Sequel.connect("sqlite://pie-man.db")

puts "* Creating the Message table..."
DB.create_table :messages do
  primary_key :id
  foreign_key :user_id, :users
  String      :author, :size => 32, :null => false
  String      :content, :text => true, :null => false
  Boolean     :protected, :default => false
  Time        :created_at, :default => Sequel::CURRENT_TIMESTAMP
end
puts "* Finished creating the Message table."

puts "* Adding a dummy message for the user 'pie-man'..."
messages = DB[:messages]
messages.insert(:user_id => 1,
      :author  => 'BasicallyGod',
      :content => "pie-man does no wrong.")
puts "* Finished adding the dummy message."

DB.disconnect
