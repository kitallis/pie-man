class User < Sequel::Model
  one_to_many :messages
end

DB = Sequel.connect("sqlite://pie-man.db")
User.dataset = DB[:users]
