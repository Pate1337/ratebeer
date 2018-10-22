require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: ['headless', 'disable-gpu']  }
      )
  
      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        desired_capabilities: capabilities      
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:"Koff")
    @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows one known beer", js:true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  it "by default beers are sorted by name", js:true do
    visit beerlist_path
    order = ["Fastenbier", "Lechte Weisse", "Nikolai"]

    for i in 0..2
      expect(find('table').find("tr:nth-child(#{i + 2})")).to have_content order[i]
    end
  end

  it "when clicking style, beers are sorted by style name", js:true do
    visit beerlist_path
    click_link "style"

    order = [@style1.name, @style2.name, @style3.name]
    for i in 0..2
      expect(find('table').find("tr:nth-child(#{i + 2})")).to have_content order[i]
    end
  end

  it "when clickin brewery, beers are sorted by brewery name", js:true do
    visit beerlist_path
    click_link "brewery"

    order = [@brewery3.name, @brewery1.name, @brewery2.name]
    for i in 0..2
      expect(find('table').find("tr:nth-child(#{i + 2})")).to have_content order[i]
    end
  end
end