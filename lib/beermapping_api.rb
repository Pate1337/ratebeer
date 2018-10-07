class BeermappingApi
  def self.places_in(city)
    city = city.downcase

    Rails.cache.fetch(city, expires_in: 24.hours) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.find(id, city)
    city = city.downcase
    # Ensin katsotaan onko välimuistissa äsköisellä haulla, esim 'helsinki'. Jos on, etsi id:n perusteella
    # Jos ei ole, pitää tehä requesti uusiks äsköseen hakuun 'helsinki'
    # Sit etsitään välimuistista
    places = Rails.cache.read(city)
    if places == nil then
      places = get_places_in(city)
    end
    place = 0
    places.each do |p|
      if (p.id == id) then
        place = p
      end
    end

    place
  end

  def self.key
    raise "BEERMAPPING_APIKEY env variable not defined" if ENV['BEERMAPPING_APIKEY'].nil?
    ENV['BEERMAPPING_APIKEY']
  end
end