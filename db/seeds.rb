if Location.count.zero?
    locations = [
        {name: 'Selina Casco Viejo Panama City', country: 'Panama', lat: 8.9541562, lng: -79.5398288},
        {name: 'Selina Panama', country: 'Panama', lat: 9.0670827, lng: -79.4926779},
        {name: 'Selina Medellin', country: 'Colombia', lat: 6.2076514, lng: -75.5661938}, 
      ]

    locations.each do |loc|
        location = Location.new
        location.name = loc[:name]
        location.country = loc[:country]
        location.lat = loc[:lat]
        location.lng = loc[:lng]
        location.save!
    end
end

if RoomType.count.zero?
    room_types = [{'room_type': 0, 'guests_amount': 8, 'price_per_night': 10},
        {'room_type': 0, 'guests_amount': 8, 'price_per_night': 10},
        {'room_type': 1, 'guests_amount': 2, 'price_per_night': 20},
        {'room_type': 1, 'guests_amount': 2, 'price_per_night': 20},
        {'room_type': 1, 'guests_amount': 2, 'price_per_night': 20},
        {'room_type': 2, 'guests_amount': 2, 'price_per_night': 30},
        {'room_type': 2, 'guests_amount': 2, 'price_per_night': 30},
        {'room_type': 2, 'guests_amount': 2, 'price_per_night': 30}]

    Location.all.each do |loc|
        room_types.each_with_index do |room_type, index|
            room = RoomType.new
            room.location_id = loc.id
            room.room_type = room_type[:room_type]
            room.guests_amount = room_type[:guests_amount]
            room.price_per_night = room_type[:price_per_night]
            room.save!
        end
    end    
end


