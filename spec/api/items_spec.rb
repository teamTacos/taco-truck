require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Locations API' do
  let(:user) { FactoryGirl.create(:user, email: "fake@fakeremail.com", fb_user_id: "10208475170966410") }
  let(:location) { FactoryGirl.create(:location, user_id: user.id) }
  let(:item) { FactoryGirl.create(:item, location_id: location.id, user_id: user.id) }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_return({"email" => "fake@fakeremail.com",
                                                                                                        "first_name" => "Booger",
                                                                                                        "last_name" => "Picker",
                                                                                                        "id" => "10208475170966410"
                                                                                                       })
  end

  context "GET" do
    it "sends a list of items for a location" do
      FactoryGirl.create_list(:item, 15, location_id: location.id, user_id: user.id)

      get "/api/v1/locations/#{location.id}/items"

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body).size).to eql 15
    end

    it "sends a item by id" do
      get "/api/v1/locations/#{location.id}/items/#{item.id}"

      expect(response.code).to eql "200"
      expect(response.body).to eql item.to_json
    end

    it "returns all images" do
      FactoryGirl.create_list(:image, 4, location_id: location.id, item_id: item.id, user_id: user.id)

      get "/api/v1/locations/#{location.id}/items/#{item.id}"

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body)['all_images'].count).to eql 4
    end

    it "returns the count of the reviews" do
      FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

      get "/api/v1/locations/#{location.id}/items/#{item.id}"
      expect(JSON.parse(response.body)["reviews_count"]).to eql 5
    end

    it "returns the average of the ratings" do
      FactoryGirl.create_list(:review, 5, item_id: item.id, rating: 3)

      get "/api/v1/locations/#{location.id}/items/#{item.id}"

      expect(JSON.parse(response.body)["reviews_average"]).to eql 3
    end
  end

  context "POST" do
    it "required a token to create" do
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_call_original

      post "/api/v1/locations/#{location.id}/items"

      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials."
    end

    it "creates an item" do
      item = FactoryGirl.build(:item, location_id: location.id)
      body = {
          name: item.name,
          description: item.description
      }

      post "/api/v1/locations/#{location.id}/items", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "201"
      expect(Item.exists?(JSON.parse(response.body)['id'])).to be
    end

    it "requires a name to create" do
      item = FactoryGirl.build(:item, location_id: location.id)
      body = {
          description: item.description
      }

      expect { post "/api/v1/locations/#{location.id}/items", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" } }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context "PUT" do
    it "required a token to update" do
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_call_original

      put "/api/v1/locations/#{location.id}/items/#{item.id}"

      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials."
    end

    it "updates an item" do
      item.name = Faker::Name.name

      put "/api/v1/locations/#{location.id}/items/#{item.id}", JSON.parse(item.to_json), { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "204"
      expect(Item.find(item.id).name).to eql item.name
    end
  end

  context "DELETE" do
    it "required a token to delete" do
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_call_original

      delete "/api/v1/locations/#{location.id}/items/#{item.id}"

      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials."
    end

    it "deletes an item" do
      delete "/api/v1/locations/#{location.id}/items/#{item.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "204"
      expect(Item.exists?(item.id)).to be false
    end

    it "will not delete and item that has reviews" do
      FactoryGirl.create(:review, item_id: item.id)

      delete "/api/v1/locations/#{location.id}/items/#{item.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "406"
      expect(JSON.parse(response.body)['errors']).to eql 'Cannot delete Item that has Reviews.'
    end

    it "will not delete an item owned by another user" do
      user2 = FactoryGirl.create(:user)
      item = FactoryGirl.create(:item, location_id: location.id, user_id: user2.id)

      expect{ delete "/api/v1/locations/#{location.id}/items/#{item.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }}.to raise_error(Pundit::NotAuthorizedError)
    end

    it "deletes all item associated images" do
      FactoryGirl.create_list(:image, 4, item_id: item.id)

      delete "/api/v1/locations/#{location.id}/items/#{item.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "204"
      expect(Image.where(item_id: item.id).count).to eql 0
    end
  end
end