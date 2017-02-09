require_relative '../rails_helper'
require_relative '../spec_helper'

describe 'Users API' do
  let(:user) { FactoryGirl.create(:user, email: "adairjk@yahoo.com", fb_user_id: "10208972170956420") }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:verify_facebook_signon_status).and_return({"email" => "adairjk@yahoo.com",
                                                                                                        "first_name" => "Jarod",
                                                                                                        "last_name" => "Adair",
                                                                                                        "id" => "10208972170956420"
                                                                                                       })
  end

  context "GET" do
    it "returns a user record by id" do
      get "/api/v1/users/#{user.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "200"
      expect(response.body).to eql user.to_json
    end

    it "returns all images" do
    end
  end

  context "POST" do
    it "creates a user" do
      user = FactoryGirl.build(:user)
      body = {
          fb_user_id: user.fb_user_id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          access_token: user.access_token
      }

      post "/api/v1/users", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "201"
      expect(User.find(JSON.parse(response.body)['id'])).to be
    end

    it "requires email to create" do
      user = FactoryGirl.build(:user)
      body = {
          fb_user_id: user.fb_user_id,
          first_name: user.first_name,
          last_name: user.last_name,
          access_token: user.access_token
      }

      expect { post "/api/v1/users", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" } }.to raise_error(ActionController::ParameterMissing)
    end

    it "requires fb_user_id to create" do
      user = FactoryGirl.build(:user)
      body = {
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          access_token: user.access_token
      }

      expect { post "/api/v1/users", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" } }.to raise_error(ActionController::ParameterMissing)
    end

    it "requires first name to create" do
      user = FactoryGirl.build(:user)
      body = {
          fb_user_id: user.fb_user_id,
          email: user.email,
          last_name: user.last_name,
          access_token: user.access_token
      }

      expect { post "/api/v1/users", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" } }.to raise_error(ActionController::ParameterMissing)
    end

    it "requires last name to create" do
      user = FactoryGirl.build(:user)
      body = {
          fb_user_id: user.fb_user_id,
          email: user.email,
          first_name: user.first_name,
          access_token: user.access_token
      }

      expect { post "/api/v1/users", body, { "Authorization" =>  "Bearer testtokenblahfoobarf" } }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context "PUT" do
    it "updates a user record" do
      user.first_name = Faker::Name.first_name

      put "/api/v1/users/#{user.id}", JSON.parse(user.to_json), { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "204"
      expect(User.find(user.id).first_name).to eql user.first_name
    end
  end

  context "DELETE" do
    it "deletes a user record" do
      delete "/api/v1/users/#{user.id}", {}, { "Authorization" =>  "Bearer testtokenblahfoobarf" }

      expect(response.code).to eql "204"
      expect(User.exists?(user.id)).to be false
    end
  end
end

