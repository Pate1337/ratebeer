class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user
  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    # palauta listalta parhaat n kappaletta
    return sorted_by_rating_in_desc_order.first(n)
    # miten? ks. http://www.ruby-doc.org/core-2.5.1/Array.html
  end
end
