class Message < Sequel::Model
  many_to_one :user

  class << self
    def leave!(attrs = {})
      to = attrs[:to]
      from = attrs[:from]

      user = User.freate(to)
      author = User.freate(from)

      insert(:user_id => user.id,
      :author => author.name,
      :content => attrs[:content])
    end

    def give(attrs = {})
      who = attrs[:who]

      user = User.freate(who)
      user.messages.inject([]) do |messages, message|
        messages << message.sanitize
        message.delete
        messages
      end
    end
  end

  def sanitize
    "#{author} said '#{content}' at #{created_at}"
  end
end

Message.dataset = DB[:messages]
