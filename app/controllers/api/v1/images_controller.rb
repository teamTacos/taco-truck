module Api
  module V1
    class ImagesController < ApplicationController
      before_filter :find_image, only: [:show, :update, :destroy]

      def index
        render json: Image.all
      end

      def show
        render json: @image
      end

      def create
        if @image.present?
          render nothing: true, status: :conflict
        else
          @image = Image.new
          @image.assign_attributes(image_params)
          if @image.save
            render json: @image, status: :created
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def update
        @image.assign_attributes(image_params)
        if @image.save
          render json: @image, status: :no_content
        else
          render nothing: true, status: :bad_request
        end
      end

      def destroy
        @image.delete
        render nothing: true, status: :no_content
      end

      private

      def find_image
        @image = Image.find(params[:id])
      end

      def image_params
        params.permit(:cloudinary_id, :location_id, :review_id, :item_id)
      end

    end
  end
end
