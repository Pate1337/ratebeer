class Style < ApplicationRecord
  has_many :beers

  def average_rating
    return 0 if beers.empty?
    sum = 0
    ratings_average = beers.each{ |b| sum += b.average_rating || 0 }
    average = sum / beers.length
    return average
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating || 0) }

    # palauta listalta parhaat n kappaletta
    return sorted_by_rating_in_desc_order.first(n)
    # miten? ks. http://www.ruby-doc.org/core-2.5.1/Array.html
  end

  def to_s
    "#{name}"
  end
end