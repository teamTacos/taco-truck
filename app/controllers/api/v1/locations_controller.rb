module Api
  module V1
    class LocationsController < ApplicationController
      before_action :find_location, only: [:show, :update, :destroy]

      def index
        render json: Location.where(query_params)
      end

      def show
        render json: @location
      end

      def create
        if @location.present?
          head :no_content, status: :conflict
        else
          @location = Location.new
          @location.assign_attributes(create_params)
          if @location.save
            render json: @location, status: :created
          else
            head :no_content, status: :bad_request
          end
        end
      end

      def update
        authorize @location
        @location.update_attributes!(update_params)
        if @location.save
          render json: @location, status: :no_content
        else
          head :no_content, status: :bad_request
        end
      end

      def destroy
        authorize @location
        if @location.items_count > 0
          render json: { errors: 'Cannot delete Location that has Items.' }, status: :not_acceptable
        else
          @location.remove_images
          @location.delete
          head :no_content, status: :no_content
        end
      end

      private

      def find_location
        @location = Location.find(params[:id])
      end

      def create_params
        params[:user_id] = session[:current_user][:id]
        params.require(:name)
        params.require(:city)
        params.require(:state)
        params.require(:country)
        params.permit(:name, :city, :state, :country, :description, :created_by, :banner_image)
      end

      def update_params
        params.permit(:name, :city, :state, :country, :description, :created_by, :banner_image)
      end

      def query_params
        params.permit(:user_id)
      end
    end
  end
end
