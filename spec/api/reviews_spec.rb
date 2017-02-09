require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Reviews API' do
  let(:user) { FactoryGirl.create(:user, email: "adairjk@yahoo.com", fb_user_id: "10208972170956420") }
  let(:location) { FactoryGirl.create(:location, user_id: user.id) }
  let(:item) { FactoryGirl.create(:item, location_id: location.id, user_id: user.id) }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_return({"email" => "adairjk@yahoo.com",
                                                                                                        "first_name" => "Jarod",
                                                                                                        "last_name" => "Adair",
                                                                                                        "id" => "10208972170956420"
                                                                                                       })
  end

  context "GET" do
    it "sends a list of reviews for an item" do
      FactoryGirl.create_list(:review, 3, item_id: item.id, user_id: user.id)

      get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response).to be_success
      expect(JSON.parse(response.body).size).to eql 3
    end

    it "sends a review by id" do
      review = FactoryGirl.create(:review, item_id: item.id, user_id: user.id)

      get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "200"
      expect(response.body).to eql review.to_json
    end

    it "returns all images" do
      review = FactoryGirl.create(:review, item_id: item.id, user_id: user.id)
      FactoryGirl.create_list(:image, 4, location_id: location.id, review_id: review.id, user_id: user.id)

      get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body)['all_images'].count).to eql 4
    end
  end

  context "POST" do
    it "creates an review" do
      review = FactoryGirl.build(:review, item_id: item.id, user_id: user.id)
      body = {
          item_id: item.id,
          description: review.description,
          rating: review.rating
      }

      post "/api/v1/locations/#{location.id}/items/#{item.id}/reviews", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "201"
      expect(Review.exists?(JSON.parse(response.body)['id'])).to be
    end

    it "requires description" do
      review = FactoryGirl.build(:review, item_id: item.id)
      body = {
          item_id: item.id,
          rating: review.rating
      }

      expect { post "/api/v1/locations/#{location.id}/items/#{item.id}/reviews", body , { "Authorization" =>  "Bearer testtokenblahfoobarf" }}.to raise_error(ActionController::ParameterMissing)
    end

    it "requires rating" do
      review = FactoryGirl.build(:review, item_id: item.id)
      body = {
          item_id: item.id,
          description: review.description,
      }

      expect { post "/api/v1/locations/#{location.id}/items/#{item.id}/reviews", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" } }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context "PUT" do
    it "updates a review" do
      review = FactoryGirl.create(:review, item_id: item.id, user_id: user.id)
      review.description = Faker::Lorem.sentence

      put "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}", JSON.parse(review.to_json), { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "204"
      expect(Review.find(review.id).description).to eql review.description
    end
  end

  context "DELETE" do
    it "deletes an review" do
      review = FactoryGirl.create(:review, item_id: item.id, user_id: user.id)

      delete "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "204"
      expect(Review.exists?(review.id)).to be false
    end

    it "will not delete a review owned by another user" do
      user2 = FactoryGirl.create(:user)
      review = FactoryGirl.create(:review, item_id: item.id, user_id: user2.id)

      expect{ delete "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" } }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "deletes all review associated images" do
      review = FactoryGirl.create(:review, item_id: item.id, user_id: user.id)
      FactoryGirl.create_list(:image, 4, review_id: review.id, user_id: user.id)

      delete "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "204"
      expect(Image.where(review_id: review.id).count).to eql 0
    end
  end
end