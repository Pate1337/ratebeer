class User < ApplicationRecord
  include RatingAverage
  has_many :ratings, dependent: :destroy # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  validates :username, uniqueness: true, length: { minimum: 3 }
  validates :password, presence: true, length: { minimum: 4 }
  validate :password_must_contain_uppercase_and_number
  has_secure_password

  def average
    average_rating
  end

  def self.most_ratings(n)
    sorted_by_rating_count_in_desc_order = User.all.sort_by{ |u| -(u.ratings.length || 0) }

    # palauta listalta parhaat n kappaletta
    return sorted_by_rating_count_in_desc_order.first(n)
    # miten? ks. http://www.ruby-doc.org/core-2.5.1/Array.html
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def password_must_contain_uppercase_and_number
    errors.add(:password, "must contain atleast one uppercase letter and number") if password !~ /^(?=.*\d)(?=.*[A-Z])/
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    style_ratings = ratings.group_by{ |r| r.beer.style }
    averages = style_ratings.map do |style, ratings|
      { style: style, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:style]
  end

  def favorite_brewery
    return nil if ratings.empty?

    style_ratings = ratings.group_by{ |r| r.beer.brewery }
    averages = style_ratings.map do |brewery, ratings|
      { brewery: brewery, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:brewery]
  end

  def to_s
    "#{username}"
  end
end
