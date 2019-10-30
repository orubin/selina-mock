require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
    it "responds successfully with an HTTP 200 status code" do
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template("locations")
        map_params = assigns(:locations_props)
        expect(map_params[:locations].size).to eq(0)
        expect(map_params[:zoom]).to eq(6)
    end

    it "renders location from DB" do
        Location.create() # empty one
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template("locations")
        map_params = assigns(:locations_props)
        expect(map_params[:locations].size).to eq(1)
    end

    it "renders location from DB" do
        Location.create(name: 'Test Location')
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template("locations")
        map_params = assigns(:locations_props)
        expect(map_params[:locations].first['name']).to eq('Test Location')
    end
end
