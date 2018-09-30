class User < ApplicationRecord
  include RatingAverage
  has_many :ratings, dependent: :destroy # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :beer_clubs
  validates :username, uniqueness: true, length: { minimum: 3 }
  validates :password, presence: true, length: { minimum: 4 }
  validate :password_must_contain_uppercase_and_number
  has_secure_password

  def average
    average_rating
  end

  def password_must_contain_uppercase_and_number
    errors.add(:password, "must contain atleast one uppercase letter and number") if password !~ /^(?=.*\d)(?=.*[A-Z])/
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end
end
