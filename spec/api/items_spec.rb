require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Locations API' do
  it "sends a list of items for a location" do
    location = FactoryGirl.create(:location)
    FactoryGirl.create_list(:item, 15, location_id: location.id)

    get "/api/v1/locations/#{location.id}/items"
    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(JSON.parse(response.body).size).to eq(15)
  end

  it "sends a item by id" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)

    get "/api/v1/locations/#{location.id}/items/#{item.id}"

    expect(response).to be_success
    expect(response.body).to eql item.to_json
  end

  it "creates an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.build(:item, location_id: location.id)
    body = {
        name: item.name,
        description: item.description
    }.to_json

    post "/api/v1/locations/#{location.id}/items", body: body

    expect(response).to be_success
  end

  it "updates an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    item.name = 'Updated Item'

    put "/api/v1/locations/#{location.id}/items/#{item.id}", body: location.to_json

    expect(response).to be_success
  end

  it "deletes an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)

    delete "/api/v1/locations/#{location.id}/items/#{item.id}"

    expect(response).to be_success
  end

  it "has count of revies" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:review, 5, item_id: item.id)

    expect(item.reviews_count).to eql 5
  end

  it "averages review values" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

    expect(item.reviews_average).to eql 3
  end
end