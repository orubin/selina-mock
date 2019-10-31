require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :request do

    describe "POST check_rooms" do

        CHECK_ROOMS_URL = '/api/v1/check_rooms'

        it "returns 400 for missing params" do
            post CHECK_ROOMS_URL
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['success']).to eq false
        end

        it "returns 400 for partly missing parms" do
            post CHECK_ROOMS_URL, :params => { :location_id => 1 }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['success']).to eq false
        end

        it "returns 400 for incorrect params" do
            post CHECK_ROOMS_URL, :params => {
                :location_id => 1,
                :start_date => Date.current,
                :end_date => 'aaa'
            }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['success']).to eq false
        end

        it "returns 200 for good params" do
            post CHECK_ROOMS_URL, :params => {
                :location_id => 1,
                :start_date => Date.current,
                :end_date => Date.current
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
        end

        it "returns empty data for non existing location" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            
            post CHECK_ROOMS_URL, :params => {
                :location_id => location.id + 1,
                :start_date => Date.current,
                :end_date => Date.current
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
            expect(JSON.parse(response.body)['data'].size).to eq(0)
        end

        it "returns data according to database" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            
            post CHECK_ROOMS_URL, :params => {
                :location_id => location.id,
                :start_date => Date.current,
                :end_date => Date.current
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
            expect(JSON.parse(response.body)['data'].size).to eq(1)
            expect(JSON.parse(response.body)['data'].first).to eq({"name"=>"DORM", "price"=>100.0, "capacity"=>1})
        end

        it "returns two rooms for location" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            RoomType.create(location_id: location.id, room_type: 1, guests_amount: 2, price_per_night: 200)
            
            post CHECK_ROOMS_URL, :params => { 
                :location_id => location.id,
                :start_date => Date.current,
                :end_date => Date.current
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
            expect(JSON.parse(response.body)['data'].size).to eq(2)
        end

        it "returns one room for location when two locations are in the db" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            RoomType.create(location_id: location.id + 1, room_type: 1, guests_amount: 2, price_per_night: 200)
            
            post CHECK_ROOMS_URL, :params => { 
                :location_id => location.id,
                :start_date => Date.current,
                :end_date => Date.current
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
            expect(JSON.parse(response.body)['data'].size).to eq(1)
        end

        it "returns no rooms when there is an order that occupies the room - overlapping interval" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            user = User.create(name: 'User Name')
            Order.create(location_id: location.id,
                room_type: 0, status: 1,
                user_id: user.id,
                start_date: Date.yesterday,
                end_date: Date.current + 1.day)
            
            post CHECK_ROOMS_URL, :params => { 
                :location_id => location.id,
                :start_date => Date.current,
                :end_date => Date.current
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
            expect(JSON.parse(response.body)['data'].size).to eq(0)
        end

        it "returns rooms when there is an order that does not occupy the room" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            user = User.create(name: 'User Name')
            Order.create(location_id: location.id,
                room_type: 0, status: 1,
                user_id: user.id,
                start_date: Date.current + 1.day,
                end_date: Date.current + 3.day)
            
            post CHECK_ROOMS_URL, :params => { 
                :location_id => location.id,
                :start_date => Date.current,
                :end_date => Date.current
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
            expect(JSON.parse(response.body)['data'].size).to eq(1)
        end

        it "returns no rooms when there is an order that occupies the room - order finishes in the interval" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            user = User.create(name: 'User Name')
            Order.create(location_id: location.id,
                room_type: 0, status: 1,
                user_id: user.id,
                start_date: Date.current - 1.day,
                end_date: Date.current + 2.day)
            
            post CHECK_ROOMS_URL, :params => { 
                :location_id => location.id,
                :start_date => Date.current + 1.day,
                :end_date => Date.current + 3.day
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
            expect(JSON.parse(response.body)['data'].size).to eq(0)
        end
    end

    describe "POST book_room" do

        BOOK_ROOM_URL = '/api/v1/book_room'

        it "returns 400 for missing params" do
            post BOOK_ROOM_URL, :params => {}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['success']).to eq false
        end

        it "returns 400 for incorrect params" do
            post BOOK_ROOM_URL, :params => {
                :location_id => 1,
                :start_date => Date.current + 1.day,
                :end_date => 'aaa'
            }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['success']).to eq false
        end

        it "does not create order when there are no vacant rooms of the type" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            user = User.create(name: 'User Name')
            Order.create(location_id: location.id,
                room_type: 0, status: 1,
                user_id: user.id,
                start_date: Date.current - 2.day,
                end_date: Date.current + 2.day)
            
            post BOOK_ROOM_URL, :params => {
                :location_id => location.id,
                :start_date => Date.current + 1.day,
                :end_date => Date.current + 3.day,
                :room_type => 'DORM'
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq false
            expect(JSON.parse(response.body)['message']).to eq('Order not created!')
        end

        it "creates an order with the params" do
            location = Location.create(name: 'Test Name', country: 'Test Country')
            RoomType.create(location_id: location.id, room_type: 0, guests_amount: 1, price_per_night: 100)
            user = User.create(name: 'User Name')
            Order.create(location_id: location.id,
                room_type: 0, status: 1,
                user_id: user.id,
                start_date: Date.current - 2.day,
                end_date: Date.current - 1.day)
            
            post BOOK_ROOM_URL, :params => {
                :location_id => location.id,
                :start_date => Date.current + 1.day,
                :end_date => Date.current + 3.day,
                :room_type => 'DORM',
                :name => 'User Name',
                :phone => 'phone',
                :email => 'email',
                :address => 'address'
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
            expect(JSON.parse(response.body)['message']).to eq('Order created successfully')
            expect(Order.all.count).to eq(2)
        end

    end
end
