require 'rails_helper'

RSpec.describe Api::V1::LocationsController, type: :request do

    describe "POST add_location" do

        ADD_LOCATION_URL = '/api/v1/add_location'

        it "returns 400 for missing params" do
            post ADD_LOCATION_URL
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['success']).to eq false
        end

        it "returns 400 for partly missing parms" do
            post ADD_LOCATION_URL, :params => { :name => 'name' }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['success']).to eq false
        end

        it "returns 200 for good params" do
            post ADD_LOCATION_URL, :params => {
                :name => 'name',
                :country => 'country',
                :lat => 34.000,
                :lng => 34.000
            }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['success']).to eq true
        end

    end

end
