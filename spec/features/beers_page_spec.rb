require 'rails_helper'

include Helpers

describe "Beers page" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "creates a new beer when given name" do
    visit new_beer_path
    fill_in('beer_name', with: 'newBeer')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "does not add beer when not given name and shows error" do
    visit new_beer_path
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end
end