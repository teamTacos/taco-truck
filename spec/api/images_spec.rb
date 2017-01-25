require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Images API' do
  it "sends a list of images for an item" do
    location = FactoryGirl.create(:location)
    item = FactoryGirl.create(:item, location_id: location.id)
    review = FactoryGirl.create(:review, item_id: item.id)
    FactoryGirl.create_list(:image, 3, item_id: item.id, location_id: location.id, review_id: review.id)

    get "/api/v1/locations/#{location.id}/images"

    expect(response).to be_success
    expect(JSON.parse(response.body).size).to eql 3
  end

end