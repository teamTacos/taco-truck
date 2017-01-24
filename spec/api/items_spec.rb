require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Locations API' do
  it "sends a list of items for a location" do
    location = FactoryGirl.create(:location)
    FactoryGirl.create_list(:item, 15, location_id: location.id)

    get "/api/v1/locations/#{location.id}/items"

    expect(response.code).to eql "200"
    expect(JSON.parse(response.body).size).to eq(15)
  end

  it "sends a item by id" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)

    get "/api/v1/locations/#{location.id}/items/#{item.id}"

    expect(response.code).to eql "200"
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

    expect(response.code).to eql "201"
    expect(Item.exists?(JSON.parse(response.body)['id'])).to be
  end

  it "updates an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    item.name = Faker::Name.name
    put "/api/v1/locations/#{location.id}/items/#{item.id}", body: item.to_json

    expect(response.code).to eql "204"
    expect(Item.find(item.id).name).to eql item.name
  end

  it "deletes an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)

    delete "/api/v1/locations/#{location.id}/items/#{item.id}"

    expect(response.code).to eql 204
    expect(Item.exists?(item.id)).to be false
  end

  it "returns the count of the reviews" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

    get "/api/v1/locations/#{location.id}/items/#{item.id}"
    expect(JSON.parse(response.body)["reviews_count"]).to eql 5
  end

  it "returns the average of the ratings" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

    get "/api/v1/locations/#{location.id}/items/#{item.id}"

    expect(JSON.parse(response.body)["reviews_average"]).to eql 3
  end

  it "updates an item created_by field" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    item.created_by = Faker::Name.name

    put "/api/v1/locations/#{location.id}/items/#{item.id}", body: item.to_json

    expect(response.code).to eql "204"
    expect(Item.find(item.id).created_by).to eql item.created_by
  end

  it "updates an item thubnail field" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    item.thumbnail = "https://placekitten.com/g/#{Random.rand(201..300)}/#{Random.rand(201..300)}"

    put "/api/v1/locations/#{location.id}/items/#{item.id}", body: item.to_json

    expect(response.code).to eql "204"
    expect(Item.find(item.id).thumbnail).to eql item.thumbnail
  end
end