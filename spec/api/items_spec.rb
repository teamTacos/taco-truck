require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Locations API' do
  it "sends a list of items for a location" do
    location = FactoryGirl.create(:location)
    FactoryGirl.create_list(:item, 15, location_id: location.id)

    get "/api/v1/locations/#{location.id}/items"

    expect(response.code).to eql "200"
    expect(JSON.parse(response.body).size).to eql 15
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
    }

    post "/api/v1/locations/#{location.id}/items", body

    expect(response.code).to eql "201"
    expect(Item.exists?(JSON.parse(response.body)['id'])).to be
  end

  it "updates an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    item.name = Faker::Name.name
    put "/api/v1/locations/#{location.id}/items/#{item.id}", JSON.parse(item.to_json)
    expect(response.code).to eql "204"
    expect(Item.find(item.id).name).to eql item.name
  end

  it "deletes an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)

    delete "/api/v1/locations/#{location.id}/items/#{item.id}"

    expect(response.code).to eql "204"
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

    put "/api/v1/locations/#{location.id}/items/#{item.id}", JSON.parse(item.to_json)

    expect(response.code).to eql "204"
    expect(Item.find(item.id).created_by).to eql item.created_by
  end

  it "returns all images" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:image, 4, location_id: location.id, item_id: item.id)

    get "/api/v1/locations/#{location.id}/items/#{item.id}"

    expect(response.code).to eql "200"
    expect(JSON.parse(response.body)['all_images'].count).to eql 4
  end

  it "will not delete and item that has reviews" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create(:review, item_id: item.id)

    delete "/api/v1/locations/#{location.id}/items/#{item.id}"

    expect(response.code).to eql "406"
    expect(JSON.parse(response.body)['errors']).to eql 'Cannot delete Item that has Reviews.'
  end
end