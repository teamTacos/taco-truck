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
        params.permit(:cloudinary_id, :review_id, :item_id, :location_id, :location_banner, :item_banner, :review_banner)
      end

      def set_banners
        Image.where(location_id: params[:location_id]).where.not(id: @image.id).update_all(location_banner: nil) if params[:location_banner] == "1"
        Image.where(item_id: params[:item_id]).where.not(id: @image.id).update_all(item_banner: nil) if params[:item_banner] == "1"
        Image.where(review_id: params[:review_id]).where.not(id: @image.id).update_all(review_banner: nil) if params[:review_banner] == "1"
      end

    end
  end
end
