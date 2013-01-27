class User < Sequel::Model
  one_to_many :messages
end

User.dataset = DB[:users]
