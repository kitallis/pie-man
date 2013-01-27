class Message < Sequel::Model
  many_to_one :user

  class << self
    # TODO: Also upsert the user for the author.
    def leave(attrs = {})
        name = attrs[:name]
        user = User.where(:name => name)

        unless user
          user = User.create(:name => name)
        end

        insert(:user_id => user.first.id,
        :author => attrs[:author],
        :content => attrs[:content])
    end
  end
end

Message.dataset = DB[:messages]
