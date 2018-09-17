module RatingAverage
  extend ActiveSupport::Concern
 
  def average_rating
    sum = 0
    self.ratings.map { |rating| sum = sum + rating.score }
    average = sum / self.ratings.length
    puts average
    "#{average}"
  end
 end