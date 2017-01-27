module Api
  module V1
    class LocationsController < ApplicationController
      before_filter :find_location, only: [:show, :update, :destroy]

      def index
        render json: Location.all
      end

      def show
        render json: @location
      end

      def create
        if @location.present?
          render nothing: true, status: :conflict
        else
          @location = Location.new
          @location.assign_attributes(location_params)
          if @location.save
            render json: @location, status: :created
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def update
        @location.update_attributes!(location_params)
        if @location.save
          render json: @location, status: :no_content
        else
          render nothing: true, status: :bad_request
        end
      end

      def destroy
        @location.delete
        render nothing: true, status: :no_content
      end

      private

      def find_location
        @location = Location.find(params[:id])
      end

      def location_params
        params.permit(:name, :city, :state, :country, :description, :thumbnail, :created_by, :banner_image)
      end

    end
  end
end
