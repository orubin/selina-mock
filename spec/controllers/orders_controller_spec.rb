require 'spec_helper'

RSpec.describe OrdersController, type: :request do
    it "responds successfully with an HTTP 200 status code" do
        location = Location.create(name: 'Test Location')
        get "/order/#{location.id}"
        expect(response).to have_http_status(200)
        expect(response).to render_template("orders")
        location_props = assigns(:location_props)
        expect(location_props[:name]).to eq('Test Location')
    end
end
