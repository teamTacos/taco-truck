require_relative "../rails_helper"
require_relative "../spec_helper"

describe "Locations API" do
  let(:location) { FactoryGirl.create(:location) }
  let(:item) { FactoryGirl.create(:item, location_id: location.id) }

  context "GET" do
    it "returns all images" do
      FactoryGirl.create_list(:image, 4, location_id: location.id)

      get "/api/v1/locations/#{location.id}"

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body)["all_images"].count).to eql 4
    end

    it "sends a list of locations" do
      FactoryGirl.create_list(:location, 5)

      get "/api/v1/locations"

      expect(response).to be_success
      expect(JSON.parse(response.body).size).to eql 5
    end

    it "sends a location by id" do
      get "/api/v1/locations/#{location.id}"

      expect(response).to be_success
      expect(response.body).to eql location.to_json
    end

    it "returns the count of the reviews" do
      FactoryGirl.create_list(:review, 6, item_id: item.id, rating: 3)

      get "/api/v1/locations/#{location.id}"

      expect(JSON.parse(response.body)["reviews_count"]).to eql 6
    end

    it "returns a count of the items" do
      FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

      get "/api/v1/locations/#{location.id}"
      expect(JSON.parse(response.body)["items_count"]).to eql 1
    end

    it "returns the average of the ratings" do
      FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

      get "/api/v1/locations/#{location.id}"

      expect(JSON.parse(response.body)["reviews_average"]).to eql 3
    end
  end

  context "POST" do
    it "creates a location" do
      location = FactoryGirl.build(:location)
      body = {
              name: location.name,
              city: location.city,
              state: location.state,
              country: location.country,
              description: location.description
              }

      post "/api/v1/locations", body

      expect(response.code).to eql "201"
      expect(Location.exists?(JSON.parse(response.body)["id"])).to be
    end

    it "requires a city to create" do
      location = FactoryGirl.build(:location)
      body = {
          name: location.name,
          state: location.state,
          country: location.country,
          description: location.description
      }

      expect{post "/api/v1/locations", body}.to raise_error(ActionController::ParameterMissing)
    end

    it "requires a state to create" do
      location = FactoryGirl.build(:location)
      body = {
          name: location.name,
          city: location.city,
          country: location.country,
          description: location.description
      }

      expect{post "/api/v1/locations", body}.to raise_error(ActionController::ParameterMissing)
    end

    it "requires a country to create" do
      location = FactoryGirl.build(:location)
      body = {
          name: location.name,
          city: location.city,
          state: location.state,
          description: location.description
      }

      expect{post "/api/v1/locations", body}.to raise_error(ActionController::ParameterMissing)
    end

    it "requires a name to create" do
      location = FactoryGirl.build(:location)
      body = {
          city: location.city,
          state: location.state,
          country: location.country,
          description: location.description
      }

      expect{post "/api/v1/locations", body}.to raise_error(ActionController::ParameterMissing)
    end
  end

  context "PUT" do
    it "updates a location name" do
      location.name = Faker::Name.name

      put "/api/v1/locations/#{location.id}", JSON.parse(location.to_json)

      expect(response.code).to eql "204"
      expect(Location.find(location.id).name).to eql location.name
    end

    it "updates a location created_by field" do
      location.created_by = Faker::Name.name

      put "/api/v1/locations/#{location.id}", JSON.parse(location.to_json)

      expect(response.code).to eql "204"
      expect(Location.find(location.id).created_by).to eql location.created_by
    end
  end

  context "DELETE" do
    it "deletes a location" do
      delete "/api/v1/locations/#{location.id}"

      expect(response.code).to eql "204"
      expect(Location.exists?(location.id)).to be false
    end

    it "will not delete a location that has items" do
      FactoryGirl.create_list(:item, Random.rand(1..5), location_id: location.id)

      delete "/api/v1/locations/#{location.id}"

      expect(response.code).to eql "406"
      expect(JSON.parse(response.body)["errors"]).to eql "Cannot delete Location that has Items."
    end
  end
end