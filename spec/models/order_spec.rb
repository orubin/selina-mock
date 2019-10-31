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

  describe "get_orders_in_interval" do

    it "checks for empty response from get_orders_in_interval" do
      result = Order.get_orders_in_interval(1, Date.current, Date.current)
      expect(result).to eq([])
    end

    it "checks for empty response with old orders" do
      location = Location.create(name: 'Test Location')
      user = User.create(name: 'Test User')
      Order.create(location_id: location.id,
        user_id: user.id,
        start_date: Date.current - 3.day,
        end_date: Date.current - 2.day,
        status: 1
      )
      
      result = Order.get_orders_in_interval(location.id, Date.current, Date.current + 1.day)
      expect(result).to eq([])
    end

    it "checks for empty response with cancelled orders" do
      location = Location.create(name: 'Test Location')
      user = User.create(name: 'Test User')
      Order.create(location_id: location.id,
        user_id: user.id,
        start_date: Date.current - 3.day,
        end_date: Date.current - 2.day,
        status: 2
      )
      
      result = Order.get_orders_in_interval(location.id, Date.current, Date.current + 1.day)
      expect(result).to eq([])
    end

    it "checks for response when order is in the interval" do
      location = Location.create(name: 'Test Location')
      user = User.create(name: 'Test User')
      order = Order.create(location_id: location.id,
        user_id: user.id,
        start_date: Date.current - 3.day,
        end_date: Date.current + 2.day,
        status: 1
      )
      
      result = Order.get_orders_in_interval(location.id, Date.current, Date.current + 1.day)
      expect(result.size).to eq(1)
      expect(result.first).to eq(order)
    end

    it "checks for response when order is in the interval and one is cancelled" do
      location = Location.create(name: 'Test Location')
      user = User.create(name: 'Test User')
      order = Order.create(location_id: location.id, 
        user_id: user.id, 
        start_date: Date.current - 3.day, 
        end_date: Date.current + 2.day,
        status: 1
      )
      Order.create(location_id: location.id, 
        user_id: user.id, 
        start_date: Date.current - 3.day, 
        end_date: Date.current + 2.day,
        status: 2
      )
      
      result = Order.get_orders_in_interval(location.id, Date.current, Date.current + 1.day)
      expect(result.size).to eq(1)
      expect(result.first).to eq(order)
    end

    it "checks for empty response when room type is not matching" do
      location = Location.create(name: 'Test Location')
      user = User.create(name: 'Test User')
      Order.create(location_id: location.id, 
        user_id: user.id, 
        start_date: Date.current - 3.day, 
        end_date: Date.current + 2.day,
        room_type: 1,
        status: 1
      )
      
      result = Order.get_orders_in_interval(location.id, Date.current, Date.current + 1.day, 'DORM')
      expect(result.size).to eq(0)
    end

    it "checks for response when room type is matching" do
      location = Location.create(name: 'Test Location')
      user = User.create(name: 'Test User')
      order = Order.create(location_id: location.id, 
        user_id: user.id, 
        start_date: Date.current - 3.day, 
        end_date: Date.current + 2.day,
        room_type: 0,
        status: 1
      )
      
      result = Order.get_orders_in_interval(location.id, Date.current, Date.current + 1.day, 'DORM')
      expect(result.size).to eq(1)
      expect(result.first).to eq(order)
    end

  end

end
