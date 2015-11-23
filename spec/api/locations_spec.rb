require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Locations API' do
  it "sends a list of locations" do
    FactoryGirl.create_list(:location, 5)

    get '/api/v1/locations'
    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(JSON.parse(response.body).size).to eq(5)
  end

  it "sends a location by id" do
    location = FactoryGirl.create(:location)

    get "/api/v1/locations/#{location.id}"

    expect(response).to be_success
    expect(response.body).to eql location.to_json
  end

  it "creates a location" do
    location = FactoryGirl.build(:location)
    body = {
            name: location.name,
            city: location.city,
            state: location.state,
            country: location.country,
            description: location.description
            }.to_json

    post '/api/v1/locations', body: body

    expect(response).to be_success
  end

  it "updates a location" do
    location = FactoryGirl.create(:location)
    location.name = 'Updated Name'

    put "/api/v1/locations/#{location.id}", body: location.to_json

    expect(response).to be_success
  end

  it "deletes a location" do
    location = FactoryGirl.create(:location)

    delete "/api/v1/locations/#{location.id}"

    expect(response).to be_success
  end
end