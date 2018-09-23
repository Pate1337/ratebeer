class BeerClub < ApplicationRecord
  has_many :users

  def to_s
    "#{name}"
  end
end
