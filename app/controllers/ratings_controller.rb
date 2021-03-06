class RatingsController < ApplicationController
  def index
    # expires_in määritelty ratings viewhun. Laitoin minuutin mutta kestää huomattavasti pidempään (n. 5 min)
    return if request.format.html? && fragment_exist?("ratinglist")
    @ratings = Rating.includes(:beer, :user).all
    @recent_ratings = Rating.recent
    @top_beers = Beer.top(3)
    @top_breweries = Brewery.top(3)
    @top_styles = Style.top(3)
    @users_with_most_ratings = User.most_ratings(3)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating ## virheen aiheuttanut rivi
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
