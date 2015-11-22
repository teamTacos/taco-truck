require_relative '../spec_helper'

describe 'Locations API' do
  it "sends a list of locations" do
    FactoryGirl.create(:location, 5)

    get '/api/locations'
    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json['locations'].length).to eq(5)
  end

  it "sends a location by id" do
    location = FactoryGirl.create(:location)

    get "/api/locations/#{location.id}"

    expect(response).to be_success
    expect(json).to eql location.to_json
  end

  it "creates a location" do
    location = FactoryGirl.build(:location)

    post '/api/locations', body: location

    expect(response).to be_success
  end

  it "updates a location" do
    location = FactoryGril.create(:location)
    location.name = 'Updated Name'

    put "/api/locations/#{location.id}", body: location

    expect(response).to be_success
  end

  it "deletes a location" do
    location = FactoryGirl.create(:location)

    delete "/api/locations/#{location.id}"

    expect(response).to be_success
  end

end