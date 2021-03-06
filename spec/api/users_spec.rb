require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Users API' do
  let(:user) { FactoryGirl.create(:user, email: "fake@fakeremail.com", fb_user_id: "10208475170966410") }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_return({"email" => "fake@fakeremail.com",
                                                                                                        "first_name" => "Booger",
                                                                                                        "last_name" => "Picker",
                                                                                                        "id" => "10208475170966410"
                                                                                                       })
  end

  context "GET" do
    it "returns a user record by id" do
      get "/api/v1/users/#{user.id}"

      expect(response.code).to eql "200"
      expect(response.body).to eql user.to_json
    end

    it "returns all locations by user id" do
      FactoryGirl.create_list(:location, 4, user_id: user.id)

      get "/api/v1/users/#{user.id}/locations"

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body).count).to eql 4
    end

    it "returns all items by user id" do
      location = FactoryGirl.create(:location)
      FactoryGirl.create_list(:item, 4, location_id: location.id, user_id: user.id)

      get "/api/v1/users/#{user.id}/items"

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body).count).to eql 4
    end

    it "returns all reviews by user id" do
      location = FactoryGirl.create(:location)
      item = FactoryGirl.create(:item, location_id: location.id)
      item2 = FactoryGirl.create(:item, location_id: location.id)
      FactoryGirl.create_list(:review, 3, item_id: item.id, user_id: user.id)
      FactoryGirl.create_list(:review, 2, item_id: item2.id, user_id: user.id)

      get "/api/v1/users/#{user.id}/reviews"

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body).count).to eql 5
    end

    it "returns a user by facebook user id" do
      user
      get "/api/v1/users"
      
      expect(response.body).to eql "[#{User.find(user.id).to_json}]"
    end

    it "returns all images by user id" do
      FactoryGirl.create_list(:image, 6, user_id: user.id)

      get "/api/v1/users/#{user.id}/images"

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body).count).to eql 6
    end
  end

  context "POST" do
    it "required a token to create" do
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_call_original

      post "/api/v1/users"

      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials."
    end

    it "creates a user" do
      user = FactoryGirl.build(:user)
      body = {
          fb_user_id: user.fb_user_id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
      }

      post "/api/v1/users", params: body, headers: {"Authorization" => "Bearer testtokenblahfoobarf"}

      expect(response.code).to eql "201"
      expect(User.find(JSON.parse(response.body)['id'])).to be
    end

    it "requires email to create" do
      user = FactoryGirl.build(:user)
      body = {
          fb_user_id: user.fb_user_id,
          first_name: user.first_name,
          last_name: user.last_name,
      }

      expect { post "/api/v1/users", params: body,
                    headers: {"Authorization" => "Bearer testtokenblahfoobarf"} }.to raise_error(ActionController::ParameterMissing)
    end

    it "requires fb_user_id to create" do
      user = FactoryGirl.build(:user)
      body = {
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
      }

      expect { post "/api/v1/users", params: body,
                    headers: {"Authorization" => "Bearer testtokenblahfoobarf"} }.to raise_error(ActionController::ParameterMissing)
    end

    it "requires first name to create" do
      user = FactoryGirl.build(:user)
      body = {
          fb_user_id: user.fb_user_id,
          email: user.email,
          last_name: user.last_name,
      }

      expect { post "/api/v1/users", params: body,
                    headers: {"Authorization" => "Bearer testtokenblahfoobarf"} }.to raise_error(ActionController::ParameterMissing)
    end

    it "requires last name to create" do
      user = FactoryGirl.build(:user)
      body = {
          fb_user_id: user.fb_user_id,
          email: user.email,
          first_name: user.first_name,
      }

      expect { post "/api/v1/users", params: body,
                    headers: {"Authorization" => "Bearer testtokenblahfoobarf"} }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context "PUT" do
    it "required a token to update" do
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_call_original

      put "/api/v1/users/#{user.id}"

      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials."
    end

    it "updates a user record" do
      user.first_name = Faker::Name.first_name

      put "/api/v1/users/#{user.id}", params: JSON.parse(user.to_json),
          headers: {"Authorization" => "Bearer testtokenblahfoobarf"}

      expect(response.code).to eql "204"
      expect(User.find(user.id).first_name).to eql user.first_name
    end
  end

  context "DELETE" do
    it "required a token to delete" do
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_call_original

      delete "/api/v1/users/#{user.id}"

      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials."
    end

    it "deletes a user record" do
      delete "/api/v1/users/#{user.id}", headers: {"Authorization" => "Bearer testtokenblahfoobarf"}

      expect(response.code).to eql "204"
      expect(User.exists?(user.id)).to be false
    end
  end
end

