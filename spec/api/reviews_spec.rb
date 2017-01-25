require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Reviews API' do
  it "sends a list of reviews for an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:review, 3, item_id: item.id)

    get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews"

    expect(response).to be_success
    expect(JSON.parse(response.body).size).to eql 3
  end

  it "sends a review by id" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    review = FactoryGirl.create(:review, item_id: item.id)

    get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}"

    expect(response.code).to eql "200"
    expect(response.body).to eql review.to_json
  end

  it "creates an review" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
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

  it "updates a review" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    review = FactoryGirl.create(:review, item_id: item.id)
    review.description = Faker::Lorem.sentence

    put "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}", JSON.parse(review.to_json)

    expect(response.code).to eql "204"
    expect(Review.find(review.id).description).to eql review.description
  end

  it "deletes an review" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    review = FactoryGirl.create(:review, item_id: item.id)

    delete "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}"

    expect(response.code).to eql "204"
    expect(Review.exists?(review.id)).to be false
  end
end