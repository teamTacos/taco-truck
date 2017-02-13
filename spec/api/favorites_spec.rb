require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Favorites API' do
  let(:user) { FactoryGirl.create(:user, email: "fake@fakeremail.com", fb_user_id: "10208475170966410") }
  let(:location) { FactoryGirl.create(:location, user_id: user.id) }
  let(:item) { FactoryGirl.create(:item, location_id: location.id, user_id: user.id) }
  let(:image) { FactoryGirl.create(:image, user_id: user.id) }
  let(:review) { FactoryGirl.create(:review, item_id: item.id, user_id: user.id) }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_return({"email" => "fake@fakeremail.com",
                                                                                                        "first_name" => "Booger",
                                                                                                        "last_name" => "Picker",
                                                                                                        "id" => "10208475170966410"
                                                                                                       })
  end

  context "GET" do
    it "returns all favorites by user id" do
      review2 = FactoryGirl.create(:review, item_id: item.id, user_id: user.id)
      FactoryGirl.create(:favorite, user_id: user.id, location_id: location.id)
      FactoryGirl.create(:favorite, user_id: user.id, image_id: image.id)
      FactoryGirl.create(:favorite, user_id: user.id, item_id: item.id)
      FactoryGirl.create(:favorite, user_id: user.id, review_id: review.id)
      FactoryGirl.create(:favorite, user_id: user.id, review_id: review2.id)

      get "/api/v1/users/#{user.id}/favorites"

      expect(response.code).to eql "200"
      resp = JSON.parse(response.body)
      expect(resp["locations"].count).to eql 1
      expect(resp["items"].count).to eql 1
      expect(resp["reviews"].count).to eql 2
      expect(resp["images"].count).to eql 1
    end
  end

  context "POST" do
    it "required a token to create" do
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_call_original

      post "/api/v1/users/#{user.id}/favorites"

      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials."
    end

    it "creates a favorite" do
      favorite = FactoryGirl.build(:favorite, user_id: user.id, location_id: location.id)
      body = {
          user_id: favorite.user_id,
          location_id: favorite.location_id
      }

      post "/api/v1/users/#{user.id}/favorites", params: body,
           headers: {"Authorization" => "Bearer testtokenblahfoobarf"}

      expect(response.code).to eql "201"
      expect(Favorite.find(JSON.parse(response.body)['id'])).to be
    end
  end

  context "DELETE" do
    it "required a token to delete" do
      favorite = FactoryGirl.create(:favorite, user_id: user.id, location_id: location.id)
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_call_original

      delete "/api/v1/users/#{user.id}/favorites/#{favorite.id}"

      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials."
    end

    it "deletes a favorite record" do
      favorite = FactoryGirl.create(:favorite, user_id: user.id, location_id: location.id)
      delete "/api/v1/users/#{user.id}/favorites/#{favorite.id}",
             headers: {"Authorization" => "Bearer testtokenblahfoobarf"}

      expect(response.code).to eql "204"
      expect(Favorite.exists?(favorite.id)).to be false
    end

    it "will not delete a favorite owned by another user" do
      user2 = FactoryGirl.create(:user)
      favorite2 = FactoryGirl.create(:favorite, item_id: item.id, user_id: user2.id)

      expect { delete "/api/v1/users/#{user.id}/favorites/#{favorite2.id}",
                      headers: {"Authorization" => "Bearer testtokenblahfoobarf"} }.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end

