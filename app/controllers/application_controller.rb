require 'rest-client'

class ApplicationController < ActionController::Base
  include Pundit
  before_filter :verify_token

  def verify_token
    render json: "Bad or Missing Credentials", status: 401 unless bearer_token
    fb_user = verify_facebook_signon_status
    user = find_or_create_user(fb_user)
    session[:current_user] = user
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
    user = User.find_by(email: fb_user["email"], fb_user_id: fb_user["id"])
    if user
      user
    else
      create_user(fb_user)
    end
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
    response = RestClient.get "https://graph.facebook.com/me?fields=id,first_name,last_name,email&access_token=#{bearer_token}"
    JSON.parse(response.body)
  end
end
