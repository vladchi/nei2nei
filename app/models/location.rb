class Location < ActiveRecord::Base
  belongs_to :user, :polymorphic => true
  belongs_to :posting, :polymorphic => true

  acts_as_mappable :auto_geocode => {:field => "address_line"}

  def auto_geocode_address
    address=self.send(auto_geocode_field).to_s
    geo=Geokit::Geocoders::MultiGeocoder.geocode(address)

    if geo.success
      self.send("lat=", geo.lat)
      self.send("lng=", geo.lng)
      self.send("country=", geo.country)
      self.send("city=", geo.city)
      self.send("state=", geo.state)
    else
      errors.add(auto_geocode_field, auto_geocode_error_message)
    end

    geo.success
  end
end
