require 'rails_helper'

RSpec.describe User, type: :model do
  it "Creates user" do
    User.create(name: 'Test Name')
    expect(User.all.size).to eq(1)
  end
end
