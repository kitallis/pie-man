module PieMan
  class Karma < Sequel::Model
    one_to_one :user

    class << self
      def get(name)
        user = User.where(:name => name).first
        user.nil? ? 0 : user.karma.value
      end

      def increment(name)
        update(name, 1)
      end

      def decrement(name)
        update(name, -1)
      end

      def update(name, value)
        karma = User.freate(name).karma
        karma.update(:value => (karma.value + value))
      end
    end
  end

  Karma.dataset = DB[:karma]
end
