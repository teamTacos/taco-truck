require 'rest-client'

class ApplicationController < ActionController::Base
  include Pundit
  before_filter :verify_token, only: [:destroy, :update, :create]

  def verify_token
    fb_user = verify_facebook_signon_status
    if fb_user
      user = find_or_create_user(fb_user)
      session[:current_user] = user
    else
      render json: {"error":"Bad or Missing Credentials"}, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= session[:current_user]
  end

  private

  def bearer_token
    pattern = /^Bearer /
    header  = request.env["HTTP_AUTHORIZATION"]
    header.gsub(pattern, '') if header && header.match(pattern)
  end

  def find_or_create_user(fb_user)
    user = User.find_by(fb_user_id: fb_user["id"])
    user ? user : create_user(fb_user)
  end

  def create_user(fb_user)
    user = User.new
    user.assign_attributes({
                               email: fb_user["email"],
                               fb_user_id: fb_user["id"],
                               first_name: fb_user["first_name"],
                               last_name: fb_user["last_name"]
                           })
    user.save!
    user
  end

  def verify_facebook_signon_status
    begin
      return false unless bearer_token
      response = RestClient.get "https://graph.facebook.com/me?fields=id,first_name,last_name,email&access_token=#{bearer_token}"
      JSON.parse(response.body)
    rescue RestClient::BadRequest
      false
    end
  end
end
