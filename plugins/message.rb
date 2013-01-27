class Message < Sequel::Model
  many_to_one :user

  class << self
    def leave(attrs = {})
      to = attrs[:to]
      from = attrs[:from]

      user = User.freate(to)
      author = User.freate(from)

      insert(:user_id => user.id,
      :author => author.name,
      :content => attrs[:content])
    end
  end
end

Message.dataset = DB[:messages]
