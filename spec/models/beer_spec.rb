require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a name, style and brewery" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }

    it "is saved" do
      expect(test_beer.valid?).to be(true)
      expect(Beer.count).to eq(1)
    end
  end

  describe "without a name" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:beer) { Beer.create style:"teststyle", brewery: test_brewery }

    it "is not saved" do
      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end
  end

  describe "without a style" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:beer) { Beer.create name:"testbeer", brewery: test_brewery }

    it "is not saved" do
      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end
  end
end
