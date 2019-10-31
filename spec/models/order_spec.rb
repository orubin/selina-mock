require 'rails_helper'

RSpec.describe Order, type: :model do

  it "does not create order when there is no user" do
    location = Location.create(name: 'Location Name', country: 'Country Name')
    Order.create(location_id: location.id, room_type: 0, status: 1)
    expect(Order.all.size).to eq(0)
  end

  it "does not create order when there is no location" do
    user = User.create(name: 'Test Name')
    Order.create(location_id: 1, room_type: 0, status: 1, user_id: user.id)
    expect(Order.all.size).to eq(0)
  end

  it "creates order" do
    user = User.create(name: 'Test Name')
    location = Location.create(name: 'Location Name', country: 'Country Name')
    Order.create(location_id: location.id, room_type: 0, status: 1, user_id: user.id)
    expect(Order.all.size).to eq(1)
  end

end
