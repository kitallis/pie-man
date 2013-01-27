class User < Sequel::Model
  one_to_many :messages
  one_to_one  :karma

  class << self
    def freate(name)
      user = where(:name => name)
      user.empty? ? create(:name => name) : user.first
    end
  end
end

User.dataset = DB[:users]
