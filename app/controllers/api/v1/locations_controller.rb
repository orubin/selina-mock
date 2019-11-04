class Api::V1::LocationsController < Api::V1::BaseController
    before_action :set_params

    def add_location
        render json: { success: false }, status: 400 and return unless validate_params
        location = Location.create(name: @name, country: @country, lat: @lat, lng: @lng)
        @rooms.each do |room|
            RoomType.create(
                location_id: location.id,
                room_type: room[:type],
                price_per_night: room[:price],
                guests_amount: room[:guests_amount])
        end
        render json: { success: true, data: { message: 'Location added successfully' } }
    end

    private

    def validate_params
        return false unless @name
        return false unless @country
        return false unless @lng
        return false unless @lat
        true
    end

    def set_params
        @name = params[:name]
        @country = params[:country]
        @lat = params[:lat]
        @lng = params[:lng]
        @rooms = params[:rooms] || []
    end

end