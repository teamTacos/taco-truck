module Api
  module V1
    class ItemsController < ApplicationController
      before_action :find_item, only: [:show, :update, :destroy]

      def index
        render json: Item.where(query_params)
      end

      def show
        render json: @item
      end

      def create
        if @location.present?
          head :no_content, status: :conflict
        else
          @item = Item.new
          @item.assign_attributes(create_params)
          if @item.save
            render json: @item, status: :created
          else
            head :no_content, status: :bad_request
          end
        end
      end

      def update
        authorize @item
        @item.update_attributes(update_params)
        if @item.save
          render json: @item, status: :no_content
        else
          head :no_content, status: :bad_request
        end
      end

      def destroy
        authorize @item
        if @item.reviews_count > 0
          render json: { errors: 'Cannot delete Item that has Reviews.' }, status: :not_acceptable
        else
          @item.remove_images
          @item.delete
          head :no_content, status: :no_content
        end
      end

      private

      def find_item
        @item = Item.find(params[:id])
      end

      def create_params
        params[:user_id] = session[:current_user][:id]
        params.require(:location_id)
        params.require(:name)
        params.permit(:name, :description, :location_id, :created_by, :user_id)
      end

      def update_params
        params.permit(:name, :description, :location_id, :created_by)
      end

      def query_params
        params.permit(:user_id, :location_id)
      end
    end
  end
end
