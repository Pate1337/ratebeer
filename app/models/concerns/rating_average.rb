module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    sum = 0
    ratings.map { |rating| sum += rating.score }
    average = sum / ratings.length.to_f
    puts average
    average.to_s
  end
end
