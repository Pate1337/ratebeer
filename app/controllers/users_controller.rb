class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_admin, only: [:toggle_closed]

  # GET /users
  # GET /users.json
  def index
    # @users = User.all
    @users = User.includes(:ratings, :beers).all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @confirmed_beerclubs = []
    @applied_beerclubs = []
    @user.memberships.each do |m|
      if m.confirmed
        @confirmed_beerclubs.push(m.beer_club)
      else
        @applied_beerclubs.push(m.beer_club)
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def toggle_closed
    user = User.find(params[:id])
    user.update_attribute :closed, (not user.closed)
  
    new_status = user.closed? ? "closed" : "opened"
  
    redirect_to user, notice:"Account #{user.username} #{new_status}"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.admin = false
    @user.closed = false

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if user_params[:username].nil? && @user == current_user && @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy if current_user == @user
    respond_to do |format|
      session[:user_id] = nil
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
