require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Images API' do
  let(:location) { FactoryGirl.create(:location) }
  let(:item) { FactoryGirl.create(:item, location_id: location.id) }
  let(:review) { FactoryGirl.create(:review, item_id: item.id) }

   context "GET" do
     it "sends a list of images for a location" do
       FactoryGirl.create_list(:image, 3, item_id: item.id, location_id: location.id, review_id: review.id)
  
       get "/api/v1/images"
  
       expect(response).to be_success
       expect(JSON.parse(response.body).size).to eql 3
     end
  
     it "sends a list of images for a review" do
       FactoryGirl.create_list(:image, 4, item_id: item.id, location_id: location.id, review_id: review.id)
  
       get "/api/v1/images"
  
       expect(response).to be_success
       expect(JSON.parse(response.body).size).to eql 4
     end
  
     it "sends a list of images for an item" do
       FactoryGirl.create_list(:image, 2, item_id: item.id, location_id: location.id)
  
       get "/api/v1/images"
  
       expect(response).to be_success
       expect(JSON.parse(response.body).size).to eql 2
     end
  
     it "sends and image by id" do
       image = FactoryGirl.create(:image, location_id: location.id)
  
       get "/api/v1/images/#{image.id}"
  
       expect(response.code).to eql "200"
       expect(response.body).to eql image.to_json
     end
   end
  
   context "POST" do
     it "creates an image" do
       location = FactoryGirl.create(:location)
       body = {
           cloudinary_id: Faker::Lorem.characters(20),
           location_id: location.id
       }
  
       post "/api/v1/images", body
  
       expect(response.code).to eql "201"
       expect(Image.exists?(JSON.parse(response.body)['id'])).to be
     end
  
     it "requires a couldinary id" do
       body = {
           location_id: location.id
       }
  
       expect{post "/api/v1/images", body}.to raise_error(ActionController::ParameterMissing)
     end

    it "sets review_banner field" do
      body = {
          cloudinary_id: Faker::Lorem.characters(20),
          location_id: location.id,
          item_id: item.id,
          review_id: review.id,
          review_banner: 1
      }

      post "/api/v1/images", body

      expect(response.code).to eql "201"
      expect(Image.find(JSON.parse(response.body)['id'])['review_banner']).to eql 1
    end

    it "requires review and item ids to be valid combination" do
      location2 = FactoryGirl.create(:location)
      item2 = FactoryGirl.create(:item, location_id: location2.id)
      review2 = FactoryGirl.create(:review, item_id: item2.id)
      body = {
          cloudinary_id: Faker::Lorem.characters(20),
          location_id: location.id,
          item_id: item.id,
          review_id: review2.id,
          review_banner: 1
      }

      post "/api/v1/images", body

      expect(response.code).to eql "400"
      expect(JSON.parse(response.body)['error']).to eql "Invalid id combination."
    end

     it "requires review and location ids to be valid combination" do
       location2 = FactoryGirl.create(:location)
       body = {
           cloudinary_id: Faker::Lorem.characters(20),
           location_id: location2.id,
           item_id: item.id,
           review_id: review.id,
           review_banner: 1
       }

       post "/api/v1/images", body

       expect(response.code).to eql "400"
       expect(JSON.parse(response.body)['error']).to eql "Invalid id combination."
     end

     it "requires item and location ids to be valid combination" do
       location2 = FactoryGirl.create(:location)
       body = {
           cloudinary_id: Faker::Lorem.characters(20),
           location_id: location2.id,
           item_id: item.id,
           review_id: review.id,
           review_banner: 1
       }

       post "/api/v1/images", body

       expect(response.code).to eql "400"
       expect(JSON.parse(response.body)['error']).to eql "Invalid id combination."
     end

     it "sets item_banner field" do
       body = {
           cloudinary_id: Faker::Lorem.characters(20),
           location_id: location.id,
           item_id: item.id,
           item_banner: 1
       }
  
       post "/api/v1/images", body
  
       expect(response.code).to eql "201"
       expect(Image.find(JSON.parse(response.body)['id'])['item_banner']).to eql 1
     end
  
     it "sets location_banner field" do
       body = {
           cloudinary_id: Faker::Lorem.characters(20),
           location_id: location.id,
           location_banner: 1
       }
  
       post "/api/v1/images", body
  
       expect(response.code).to eql "201"
       expect(Image.find(JSON.parse(response.body)['id'])['location_banner']).to eql 1
     end
  
     it "clears all other location_banner fields when a new one is set" do
       FactoryGirl.create_list(:image, 5, location_id: location.id, location_banner: 1)
       body = {
           cloudinary_id: Faker::Lorem.characters(20),
           location_id: location.id,
           location_banner: 1
       }
  
       post "/api/v1/images", body
  
       expect(response.code).to eql "201"
       images = Image.where(location_id: location.id)
       location_banners = images.collect { |image| image.location_banner }
       expect(location_banners.compact.inject(:+)).to eql 1
       expect(Image.find(JSON.parse(response.body)['id'])['location_banner']).to eql 1
     end
   end
  
   context "DELETE" do
     it "deletes and image" do
       image = FactoryGirl.create(:image, item_id: item.id, location_id: location.id, review_id: review.id)
       delete "/api/v1/images/#{image.id}"
  
       expect(response.code).to eql "204"
       expect(Image.exists?(image.id)).to be false
     end
  end
end