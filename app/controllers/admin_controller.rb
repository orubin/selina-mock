# frozen_string_literal: true

class AdminController < ApplicationController
    layout "admin"

    LATITUDE = 9.0817275
    LONGITUDE = -79.5932217
  
    def index
      locations = Location.all
      locations_array = []
      locations.each do |loc|
        locations_array << loc.as_json
      end
      @locations_props = {
        locations: locations_array,
        zoom: 6,
        center: {
          lat: LATITUDE, lng: LONGITUDE
        }
      }
    end
  end
  