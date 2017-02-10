require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Application Controller' do
  let(:controller) { ApplicationController.new }
  let(:user) { FactoryGirl.create(:user) }

  describe '#verify_token' do
    it "should return a User" do
      allow(controller).to receive(:verify_facebook_signon_status).and_return({"email" => "fake@fakeremail.com",
                                                                               "first_name" => "Booger",
                                                                               "last_name" => "Picker",
                                                                               "id" => "10208475170966410"
                                                                              })
      allow(controller).to receive(:find_or_create_user).and_return(user)
      allow(controller).to receive(:session).and_return({})
      expect(controller.verify_token).to be_a_kind_of User
    end

    it "should raise an error" do
      allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_return(false)
      allow_any_instance_of(ApplicationController).to receive(:find_or_create_user).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:session).and_return({})
      post "/api/v1/locations", {}, { "Authorization" => '' }
      expect(response.code).to eql "401"
      expect(JSON.parse(response.body)['error']).to eql "Bad or Missing Credentials"
    end
  end

end

