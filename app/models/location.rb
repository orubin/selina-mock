class Location < ApplicationRecord
    has_many :orders

    def self.get_available_rooms(location_id, start_date, end_date, room_type = nil)
        result = []

        total_orders = Order.get_orders_in_interval(location_id, start_date, end_date, room_type)

        # get total room types and subtract reserved rooms
        room_types = RoomType.where(location_id: location_id)
        dorm_count = 0
        private_count = 0
        deluxe_count = 0

        room_types_hash = {}
        room_types.each do |room_type|
            if room_type.room_type == 0
                dorm_count += 1
                room_types_hash[:dorm] = room_type.to_json
            end
            if room_type.room_type == 1
                private_count += 1
                room_types_hash[:private] = room_type.to_json
            end
            if room_type.room_type == 2
                deluxe_count += 1
                room_types_hash[:deluxe] = room_type.to_json
            end
        end

        total_orders.each do |order|
            dorm_count -= 1 if order.room_type == 0
            private_count -= 1 if order.room_type == 1
            deluxe_count -= 1 if order.room_type == 2
        end

        result << room_types_hash[:dorm] if dorm_count > 0
        result << room_types_hash[:private] if private_count > 0
        result << room_types_hash[:deluxe] if deluxe_count > 0

        result
    end

end
