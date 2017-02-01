module Api
  module V1
    class ItemsController < ApplicationController
      before_filter :find_item, only: [:show, :update, :destroy]

      def index
        render json: Item.where(location_id: params[:location_id])
      end

      def show
        render json: @item
      end

      def create
        if @location.present?
          render nothing: true, status: :conflict
        else
          @item = Item.new
          @item.assign_attributes(create_params)
          if @item.save
            render json: @item, status: :created
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def update
        @item.update_attributes(update_params)
        if @item.save
          render json: @item, status: :no_content
        else
          render nothing: true, status: :bad_request
        end
      end

      def destroy
        if @item.reviews_count > 0
          render json: { errors: 'Cannot delete Item that has Reviews.' }, status: :not_acceptable
        else
          @item.remove_images
          @item.delete
          render nothing: true, status: :no_content
        end
      end

      private

      def find_item
        @item = Item.find(params[:id])
      end

      def create_params
        params.require(:location_id)
        params.require(:name)
        params.permit(:name, :description, :location_id, :created_by)
      end

      def update_params
        params.permit(:name, :description, :location_id, :created_by)
      end

    end
  end
end
