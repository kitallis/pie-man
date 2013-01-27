class User < Sequel::Model
  one_to_many :messages

  class << self
    def freate(name)
      user = where(:name => name)
      user.empty? ? create(:name => name) : user.first
    end
  end
end

User.dataset = DB[:users]
