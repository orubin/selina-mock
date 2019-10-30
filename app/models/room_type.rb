class RoomType < ApplicationRecord
    belongs_to :location

    module Type
        DORM = 0
        PRIVATE_ROOM = 1
        DELUXE_ROOM = 2
    end

    def to_json
        { name: get_name, price: price_per_night, capacity: guests_amount}
    end

    def get_name
        return 'DORM' if room_type == 0
        return 'PRIVATE_ROOM' if room_type == 1
        return 'DELUXE_ROOM' if room_type == 2
    end

    def self.type_by_name(name)
        return 0 if name == 'DORM'
        return 1 if name == 'PRIVATE_ROOM'
        return 2 if name == 'DELUXE_ROOM'
    end
end
