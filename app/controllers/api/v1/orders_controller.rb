class Api::V1::OrdersController < Api::V1::BaseController
    before_action :set_params

    def check_rooms
        render json: { success: false }, status: 400 and return unless validate_params
        res = Location.get_available_rooms(@location_id, @start_date, @end_date)
        render json: { success: true, data: res }
    end

    def book_room
        render json: { success: false }, status: 400 and return unless validate_params
        set_order_params
        # need to check here that there are still vacant rooms for the type
        available_rooms = Location.get_available_rooms(@location_id, @start_date, @end_date, @room_type)
        if available_rooms.size > 0
            Order.create_order(@location_id, @start_date, @end_date, @room_type, @name, @email, @phone, @address)
            render json: { success: true, message: 'Order created successfully' }
        else
            render json: { success: false, message: 'Order not created!' }
        end
    end

    private

    def validate_params
        return false unless @start_date
        return false unless @end_date
        return false unless @location_id
        begin
            Date.parse(@start_date)
            Date.parse(@end_date)
        rescue
            return false
        end
        true
    end

    def set_order_params
        @name = params[:name]
        @email = params[:email]
        @address = params[:address]
        @phone = params[:phone]
        @room_type = params[:room_type]
    end

    def set_params
        @location_id = params[:location_id].to_i
        @start_date = params[:start_date]
        @end_date = params[:end_date]
    end
end