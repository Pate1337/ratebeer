class ApplicationController < ActionController::Base
  # määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user
  helper_method :previous_search

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    redirect_to current_user, notice: 'you do not have the rights' if (current_user.nil? || current_user.admin == false)
  end

  def previous_search
    return nil if session[:search_param].nil?
    session[:search_param]
  end
end
