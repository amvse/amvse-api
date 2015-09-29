module Amvse
  class Location
    attr_accessor :id, :name, :updated_at, :yelp_id, :phone_number, :street, 
              :city, :state, :zip, :country, :website,
              :twitter, :facebook, :instagram, :foursquare, :yelp_data, :reviews_count,
              :reservations, :delivery, :take_out, :credit_cards, :bitcoin, :good_for_lunch, 
              :parking_type, :bike_parking, :wheelchair_accessible, :good_for_kids, 
              :good_for_groups, :attire_type, :ambience_type, :noise_level_type, :alcohol_type, 
              :outdoor_seating, :wifi_type, :has_tv, :waiter_service, :caters, :meals,
              :music, :smoking_type, :menus, :open_windows
    
    def initialize(attributes={})
      self.id = attributes['id']
      self.name = attributes['name']
      self.updated_at = attributes['updated_at']
      self.yelp_id = attributes['yelp_id']
      self.phone_number = attributes['phone_number']
      self.street = attributes['street']
      self.city = attributes['city']
      self.state = attributes['state']
      self.zip = attributes['zip']
      self.country = attributes['country']
      self.website = attributes['website']
      self.twitter = attributes['twitter']
      self.facebook = attributes['facebook']
      self.instagram = attributes['instagram']
      self.foursquare = attributes['foursquare']
      self.yelp_data = attributes['yelp_data']
      self.reviews_count = attributes['reviews_count']
      self.reservations = attributes['reservations']
      self.delivery = attributes['delivery']
      self.take_out = attributes['take_out']
      self.credit_cards = attributes['credit_cards']
      self.bitcoin = attributes['bitcoin']
      self.good_for_lunch = attributes['good_for_lunch']
      self.parking_type = attributes['parking_type']
      self.bike_parking = attributes['bike_parking']
      self.wheelchair_accessible = attributes['wheelchair_accessible']
      self.good_for_kids = attributes['good_for_kids']
      self.good_for_groups = attributes['good_for_groups']
      self.attire_type = attributes['attire_type']
      self.ambience_type = attributes['ambience_type']
      self.noise_level_type = attributes['noise_level_type']
      self.alcohol_type = attributes['alcohol_type']
      self.outdoor_seating = attributes['outdoor_seating']
      self.wifi_type = attributes['wifi_type']
      self.has_tv = attributes['has_tv']
      self.waiter_service = attributes['waiter_service']
      self.caters = attributes['caters']
      self.meals = attributes['meals']
      self.music = attributes['music']
      self.smoking_type = attributes['smoking_type']
      self.menus = (attributes['menus'] || []).map{|menu_json| Amvse::Menu.new(menu_json) }
      self.open_windows = (attributes['open_windows'] || []).map{|open_window_json| Amvse::OpenWindow.new(open_window_json) }
    end
    
    def serialize
      {
        'id': self.id,
        'name': self.name,
        'updated_at': self.updated_at,
        'yelp_id': self.yelp_id,
        'phone_number': self.phone_number,
        'street': self.street,
        'city': self.city,
        'state': self.state,
        'zip': self.zip,
        'country': self.country,
        'website': self.website,
        'twitter': self.twitter,
        'facebook': self.facebook,
        'instagram': self.instagram,
        'foursquare': self.foursquare,
        'yelp_data': self.yelp_data,
        'reviews_count': self.reviews_count,
        'reservations': self.reservations,
        'delivery': self.delivery,
        'take_out': self.take_out,
        'credit_cards': self.credit_cards,
        'bitcoin': self.bitcoin,
        'good_for_lunch': self.good_for_lunch,
        'parking_type': self.parking_type,
        'bike_parking': self.bike_parking,
        'wheelchair_accessible': self.wheelchair_accessible,
        'good_for_kids': self.good_for_kids,
        'good_for_groups': self.good_for_groups,
        'attire_type': self.attire_type,
        'ambience_type': self.ambience_type,
        'noise_level_type': self.noise_level_type,
        'alcohol_type': self.alcohol_type,
        'outdoor_seating': self.outdoor_seating,
        'wifi_type': self.wifi_type,
        'has_tv': self.has_tv,
        'waiter_service': self.waiter_service,
        'caters': self.caters,
        'meals': self.meals,
        'music': self.music,
        'smoking_type': self.smoking_type,
        'menus': self.menus.map{|menu| menu.serialize },
        'open_windows': self.open_windows.map{|open_window| open_window.serialize }
      }
    end
    
  end
  
  class API

    def get_locations
      request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/locations"
      ).body.map do |location_object|
        Amvse::Location.new location_object
      end
    end
    
    def get_location(id)
      Amvse::Location.new request(
        :expects  => 200,
        :method   => :get,
        :path     => "/v1/locations/#{id}"
      ).body
    end

  end
end