class Message < Sequel::Model
  many_to_one :user
end

DB = Sequel.connect("sqlite://pie-man.db")
Message.dataset = DB[:messages]
