require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Reviews API' do
  let(:location) { FactoryGirl.create(:location) }
  let(:item) { FactoryGirl.create(:item, location_id: location.id) }

  context "GET" do
    it "sends a list of reviews for an item" do
      FactoryGirl.create_list(:review, 3, item_id: item.id)

      get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews"

      expect(response).to be_success
      expect(JSON.parse(response.body).size).to eql 3
    end

    it "sends a review by id" do
      review = FactoryGirl.create(:review, item_id: item.id)

      get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}"

      expect(response.code).to eql "200"
      expect(response.body).to eql review.to_json
    end

    it "returns all images" do
      review = FactoryGirl.create(:review, item_id: item.id)
      FactoryGirl.create_list(:image, 4, location_id: location.id, review_id: review.id)

      get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}"

      expect(response.code).to eql "200"
      expect(JSON.parse(response.body)['all_images'].count).to eql 4
    end
  end

  context "POST" do
    it "creates an review" do
      review = FactoryGirl.build(:review, item_id: item.id)
      body = {
          item_id: item.id,
          description: review.description,
          rating: review.rating
      }

      post "/api/v1/locations/#{location.id}/items/#{item.id}/reviews", body

      expect(response.code).to eql "201"
      expect(Review.exists?(JSON.parse(response.body)['id'])).to be
    end

    it "requires description" do
      review = FactoryGirl.build(:review, item_id: item.id)
      body = {
          item_id: item.id,
          rating: review.rating
      }

      expect { post "/api/v1/locations/#{location.id}/items/#{item.id}/reviews", body }.to raise_error(ActionController::ParameterMissing)
    end

    it "requires rating" do
      review = FactoryGirl.build(:review, item_id: item.id)
      body = {
          item_id: item.id,
          description: review.description,
      }

      expect { post "/api/v1/locations/#{location.id}/items/#{item.id}/reviews", body }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context "PUT" do
    it "updates a review" do
      review = FactoryGirl.create(:review, item_id: item.id)
      review.description = Faker::Lorem.sentence

      put "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}", JSON.parse(review.to_json)

      expect(response.code).to eql "204"
      expect(Review.find(review.id).description).to eql review.description
    end
  end

  context "DELETE" do
    it "deletes an review" do
      review = FactoryGirl.create(:review, item_id: item.id)

      delete "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}"

      expect(response.code).to eql "204"
      expect(Review.exists?(review.id)).to be false
    end

    it "deletes all review associated images" do
      review = FactoryGirl.create(:review, item_id: item.id)
      FactoryGirl.create_list(:image, 4, review_id: review.id)

      delete "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}"

      expect(response.code).to eql "204"
      expect(Image.where(review_id: review.id).count).to eql 0
    end
  end
end