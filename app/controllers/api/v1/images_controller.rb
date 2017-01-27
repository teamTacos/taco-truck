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
            set_banners
            render json: @image, status: :created
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def update
        @image.update_attributes(image_params)
        if @image.save
          set_banners
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
        params.permit(:cloudinary_id, :review_id, :item_id, :location_id)
      end

      def set_banners
        Location.find(params[:location_id]).update(banner_image: @image.id) if params[:location_banner].eql?("true")
        Review.find(params[:review_id]).update(banner_image: @image.id) if params[:review_banner].eql?("true")
        Item.find(params[:item_id]).update(banner_image: @image.id) if params[:item_banner].eql?("true")
      end

    end
  end
end
