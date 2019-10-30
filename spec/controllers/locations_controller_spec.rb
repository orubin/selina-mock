require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
    it "responds successfully with an HTTP 200 status code" do
        get :index
        expect(response).to have_http_status(200)
    end
end
