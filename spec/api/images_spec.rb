require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Images API' do
  it "sends a list of images for a location" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    review = FactoryGirl.create(:review, item_id: item.id)
    FactoryGirl.create_list(:image, 3, item_id: item.id, location_id: location.id, review_id: review.id)

    get "/api/v1/locations/#{location.id}/images"

    expect(response).to be_success
    expect(JSON.parse(response.body).size).to eql 3
  end

  it "sends a list of images for a review" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    review = FactoryGirl.create(:review, item_id: item.id)
    FactoryGirl.create_list(:image, 4, item_id: item.id, location_id: location.id, review_id: review.id)

    get "/api/v1/locations/#{location.id}/items/#{item.id}/reviews/#{review.id}/images"

    expect(response).to be_success
    expect(JSON.parse(response.body).size).to eql 4
  end

  it "sends a list of images for an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    FactoryGirl.create_list(:image, 2, item_id: item.id, location_id: location.id)

    get "/api/v1/locations/#{location.id}/items/#{item.id}/images"

    expect(response).to be_success
    expect(JSON.parse(response.body).size).to eql 2
  end

  it "creates an image" do
    location = FactoryGirl.create(:location)
    body = {
        cloudinary_id: Faker::Lorem.characters(20),
        location_id: location.id
    }

    post "/api/v1/locations/#{location.id}/images", body

    expect(response.code).to eql "201"
    expect(Image.exists?(JSON.parse(response.body)['id'])).to be
  end

  it "deletes and image" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    review = FactoryGirl.create(:review, item_id: item.id)
    image = FactoryGirl.create(:image, item_id: item.id, location_id: location.id, review_id: review.id)
    delete "/api/v1/locations/#{location.id}/images/#{image.id}"

    expect(response.code).to eql "204"
    expect(Image.exists?(image.id)).to be false
  end

  it "sends and image by id" do
    location = FactoryGirl.create(:location)
    image = FactoryGirl.create(:image, location_id: location.id)

    get "/api/v1/locations/#{location.id}/images/#{image.id}"

    expect(response.code).to eql "200"
    expect(response.body).to eql image.to_json
  end

  it "updates location banner_image field with image id if location_banner is true" do
    location = FactoryGirl.create(:location)
    body = {
        cloudinary_id: Faker::Lorem.characters(20),
        location_id: location.id,
        location_banner: true
    }
    post "/api/v1/locations/#{location.id}/images", body

    expect(response.code).to eql "201"
    expect(Location.find(location.id)['banner_image']).to eql JSON.parse(response.body)['id']
  end
end