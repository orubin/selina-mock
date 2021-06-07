class OrdersController < ApplicationController
    layout "orders"
  
    def index
      location = Location.find(params[:id])
      @location_props = { name: location.name, location_id: location.id } if location
    end
end