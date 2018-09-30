class BeerClub < ApplicationRecord
  has_many :users

  def to_s
    name.to_s
  end
end
