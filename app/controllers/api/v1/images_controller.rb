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
        elsif !validate_ids
          render json: { error: "Invalid id combination." }, status: :bad_request
        else
          @image = Image.new
          @image.assign_attributes(create_params)
          if @image.save
            set_banners
            render json: @image, status: :created
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def update
        if !validate_ids
          render json: { error: "Invalid id combination." }, status: :bad_request
        else
          @image.update_attributes(update_params)
          if @image.save
            set_banners
            render json: @image, status: :no_content
          else
            render nothing: true, status: :bad_request
          end
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

      def update_params
        params.permit(:cloudinary_id, :review_id, :item_id, :location_id, :location_banner, :item_banner, :review_banner)
      end

      def create_params
        params.require(:cloudinary_id)
        params.permit(:cloudinary_id, :review_id, :item_id, :location_id, :location_banner, :item_banner, :review_banner)
      end

      def validate_ids
        if !params[:review_id].blank?
          return false unless validate_review_ids
        elsif !params[:item_id].blank?
          return false unless validate_item_and_location_ids
        elsif !params[:location_id]
          false
        end
        true
      end

      def validate_review_ids
        review = Review.find(params[:review_id])
        if params[:item_id]
          return false if review.item_id.to_s != params[:item_id].to_s
        else
          params[:item_id] = review.item_id
        end
        return false unless validate_item_and_location_ids
        true
      end

      def validate_item_and_location_ids
        item = Item.find(params[:item_id])
        if params[:location_id]
          return false if Item.find(item.id).location_id.to_s != params[:location_id].to_s
        else
          params[:location_id] = Item.find(item.id).location_id
        end
        true
      end

      def set_banners
        Image.where(location_id: params[:location_id]).where.not(id: @image.id).update_all(location_banner: nil) if params[:location_banner] == "1"
        Image.where(item_id: params[:item_id]).where.not(id: @image.id).update_all(item_banner: nil) if params[:item_banner] == "1"
        Image.where(review_id: params[:review_id]).where.not(id: @image.id).update_all(review_banner: nil) if params[:review_banner] == "1"
      end

    end
  end
end
