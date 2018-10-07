require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')
  
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "User's own page" do
    it "Lists only that user's ratings" do
      selected_user = FactoryBot.create(:user, username: 'selected')
      create_beers_with_many_ratings({user: selected_user}, 10, 20)
      create_beers_with_many_ratings({user: @user}, 15, 13)
      visit user_path(selected_user)

      expect(page).to have_content 'Has made 2 ratings, average rating 15.0'
      expect(page).to have_no_content 'anonymous 15'
    end
  end
end