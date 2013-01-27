module PieMan
  class Karma < Sequel::Model
    one_to_one :user
  end

  Karma.dataset = DB[:karma]
end
