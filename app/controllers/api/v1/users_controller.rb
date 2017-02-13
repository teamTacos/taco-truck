module Api
  module V1
    class UsersController < ApplicationController
      before_action :find_user, only: [:show, :update, :destroy]

      def show
        render json: @user
      end

      def create
        if @user.present?
          head :no_content, status: :conflict
        else
          @user = User.new
          @user.assign_attributes(create_params)
          if @user.save
            render json: @user, status: :created
          else
            head :no_content, status: :bad_request
          end
        end
      end

      def update
        @user.update_attributes!(update_params)
        if @user.save
          render json: @user, status: :no_content
        else
           head :no_content, status: :bad_request
        end
      end

      def destroy
        @user.delete
         head :no_content, status: :no_content
      end

      private

      def find_user
        @user = User.find(params[:id])
      end

      def create_params
        params.require(:email)
        params.require(:fb_user_id)
        params.require(:first_name)
        params.require(:last_name)
        params.permit(:fb_user_id, :access_token, :email, :first_name, :last_name)
      end

      def update_params
        params.require(:email)
        params.require(:fb_user_id)
        params.permit(:fb_user_id, :access_token, :email, :first_name, :last_name)
      end
    end
  end
end
