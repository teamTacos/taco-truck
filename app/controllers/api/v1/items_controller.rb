module Api
  module V1
    class ItemsController < ApplicationController
      before_filter :find_location, only: [:show, :update, :destroy]

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
          @item.assign_attributes(item_params)
          if @item.save
            render json: @item
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def update
        @item.assign_attributes(item_params)
        if @item.save
          render json: @item
        else
          render nothing: true, status: :bad_request
        end
      end

      def destroy
        @item.delete
        render nothing: true
      end

      private

      def find_location
        @item = Item.find(params[:id])
      end

      def item_params
        params.permit(:name, :description, :location_id)
      end

    end
  end
end
