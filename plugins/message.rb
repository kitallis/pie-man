module PieMan
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

        user.update(:message_notification => false)
      end

      def give(name)
        user = User.freate(name)
        user.messages.inject([]) do |messages, message|
          messages << message.sanitize
          message.delete
          messages
        end
      end

      def messages(name)
        user = User.where(:name => name).first

        return 0 if user.nil? || user.message_notification
        user.update(:message_notification => true)
        return user.messages.count
      end
    end

    def sanitize
      "#{author} said '#{content}' #{pretty_time}"
    end

    def pretty_time
      seconds = (Time.now.utc - created_at).to_i
      minutes, seconds = seconds.divmod(60)
      hours, minutes = minutes.divmod(60)
      days, hours = hours.divmod(24)

      if days > 0
        "%d day(s) ago." % [days]
      elsif hours > 0
        "%d hour(s), %d minute(s) ago." % [hours, minutes]
      elsif minutes > 0
        "%d minute(s), %d second(s) ago." % [minutes, seconds]
      else
        "%d second(s) ago." % [seconds]
      end
    end
  end

  Message.dataset = DB[:messages]
end
