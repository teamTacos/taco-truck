# require_relative '../spec_helper'
#
# describe 'Items API' do
#   it "sends a list of items" do
#     location = FactoryGirl.create(:location)
#     FactoryGirl.create_list(:item, 5, location_id: location.id)
#
#     get "/api/v1/locations/#{location.id}/items"
#     json = JSON.parse(response.body)
#
#     expect(response).to be_success
#     expect(json['items'].length).to eq(5)
#   end
#
#   it "sends an item by id" do
#     location = FactoryGirl.create(:location)
#     item = FactoryGirl.create(:item, location_id: location.id)
#
#     get "/api/v1/locations/#{location.id}/items/#{item.id}"
#
#     expect(response).to be_success
#     expect(json).to eql location.to_json
#   end
#
#   it "creates an item" do
#     location = FactoryGirl.create(:location)
#     item = FactoryGirl.build(:item, location_id: location.id)
#
#     post "/api/v1/locations/#{location.id}/items", body: item
#
#     expect(response).to be_success
#   end
#
#   it "updates an item" do
#     location = FactoryGirl.create(:location)
#     item = FactoryGirl.create(:item, location_id: location.id)
#     item.name = 'Updated Name'
#
#     put "/api/v1/locations/#{location.id}/items/#{item.id}", body: location
#
#     expect(response).to be_success
#   end
#
#   it "deletes an item" do
#     location = FactoryGirl.create(:location)
#     item = FactoryGirl.create(:item, location_id: item)
#
#     delete "/api/v1/locations/#{location.id}/items/#{item.id}"
#
#     expect(response).to be_success
#   end
# end