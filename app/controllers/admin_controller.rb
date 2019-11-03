# frozen_string_literal: true

class AdminController < ApplicationController
    layout "admin"
  
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
          lat: 9.0817275, lng: -79.5932217
        }
      }
    end
  end
  