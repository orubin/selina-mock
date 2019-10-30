class Order < ApplicationRecord
    belongs_to :location
    belongs_to :user

    module Status
        CONFIRMED = 1
        CANCELLED = 2
        COMPLETED = 3
    end

    def self.get_orders_in_interval(location_id, start_date, end_date, room_type = nil)

        orders_starting_inside_interval = where('start_date BETWEEN ? AND ? AND location_id = ? AND status = 1', start_date, end_date, location_id)
        orders_ending_inside_interval = where('end_date BETWEEN ? AND ? AND location_id = ? AND status = 1', start_date, end_date, location_id)
        orders_overlapping_interval = where('start_date < ? AND end_date > ? AND location_id = ? AND status = 1', start_date, end_date, location_id)

        result = orders_starting_inside_interval + orders_ending_inside_interval + orders_overlapping_interval

        if room_type
            room_type_id = RoomType.type_by_name(room_type)
            result = result.select do |order|
                order[:room_type] == room_type_id
            end
        end

        result
    end

    def self.create_order(location_id, start_date, end_date, room_type, name, email, phone, address)
        # first, create new user in the system
        user = User.where(email: email).first_or_create
        user.phone = phone
        user.address = address
        user.name = name
        user.save!

        # then, create the order
        self.create(location_id: location_id,
            start_date: start_date,
            end_date: end_date, 
            room_type: RoomType.type_by_name(room_type),
            user_id: user.id)
    end
    
end
