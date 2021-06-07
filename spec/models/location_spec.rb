require 'rails_helper'

RSpec.describe Location, type: :model do
    it 'saves location to db' do
        location = Location.create(name: 'test', country: 'country_test')
        expect Location.count == 1
    end
end