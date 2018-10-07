require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with a password too short" do
    let(:user){ User.create username:"Pekka", password:"Ju1", password_confirmation:"Ju1" }

    it "is not saved" do
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
  end

  describe "with a password consisting only of letters" do
    let(:user){ User.create username:"Pekka", password:"NytOnTarpeeksPitkä", password_confirmation:"NytOnTarpeeksPitkä" }

    it "is not saved" do
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user }, 25 )
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style of with highest average if several rated" do
      create_beers_with_many_ratings({ user: user, style: 'Lager' }, 10, 20, 15, 7, 9)
      create_beers_with_many_ratings({ user: user, style: 'IPA' }, 25, 45, 50, 50, 50 )
      create_beers_with_many_ratings({ user: user, style: 'Alt' }, 50, 10, 8)

      expect(user.favorite_style).to eq('IPA')
    end 
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated if only one rating" do
      favorite = FactoryBot.create(:brewery, name: 'Schlenkerla')
      create_beer_with_rating({ user: user, brewery: favorite }, 25)

      expect(user.favorite_brewery).to eq(favorite)
    end  
    
    it "is the brewery of with highest average if several rated" do
      favorite = FactoryBot.create(:brewery, name: 'Schlenkerla')
      b1 = FactoryBot.create(:brewery)
      b2 = FactoryBot.create(:brewery)
      create_beers_with_many_ratings({ user: user, brewery: b1 }, 10, 20, 15, 7, 9)
      create_beers_with_many_ratings({ user: user, brewery: favorite }, 25, 45 )
      create_beers_with_many_ratings({ user: user, brewery: b2 }, 50, 10, 8)

      expect(user.favorite_brewery).to eq(favorite)
    end 
  end
end
