require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Locations API' do
  it "sends a list of locations" do
    FactoryGirl.create_list(:location, 5)

    get '/api/v1/locations'

    expect(response).to be_success
    expect(JSON.parse(response.body).size).to eql 5
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
            }

    post '/api/v1/locations', body

    expect(response.code).to eql "201"
    expect(Location.exists?(JSON.parse(response.body)['id'])).to be
  end

  it "updates a location name" do
    location = FactoryGirl.create(:location)
    location.name = Faker::Name.name

    put "/api/v1/locations/#{location.id}", JSON.parse(location.to_json)

    expect(response.code).to eql "204"
    expect(Location.find(location.id).name).to eql location.name
  end

  it "updates a location created_by field" do
    location = FactoryGirl.create(:location)
    location.created_by = Faker::Name.name

    put "/api/v1/locations/#{location.id}", JSON.parse(location.to_json)

    expect(response.code).to eql "204"
    expect(Location.find(location.id).created_by).to eql location.created_by
  end

  it "deletes a location" do
    location = FactoryGirl.create(:location)

    delete "/api/v1/locations/#{location.id}"

    expect(response.code).to eql "204"
    expect(Location.exists?(location.id)).to be false
  end

  it "returns the count of the reviews" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:review, 6, item_id: item.id, rating: 3)

    get "/api/v1/locations/#{location.id}"

    expect(JSON.parse(response.body)["reviews_count"]).to eql 6
  end

  it "returns the average of the ratings" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

    get "/api/v1/locations/#{location.id}"

    expect(JSON.parse(response.body)["reviews_average"]).to eql 3
  end

  it "returns a count of the items" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

    get "/api/v1/locations/#{location.id}"
    expect(JSON.parse(response.body)["items_count"]).to eql 1
  end

  it "returns all images" do
    location = FactoryGirl.create(:location)
    FactoryGirl.create_list(:image, 4, location_id: location.id)

    get "/api/v1/locations/#{location.id}"

    expect(response.code).to eql "200"
    expect(JSON.parse(response.body)['all_images'].count).to eql 4
  end
end