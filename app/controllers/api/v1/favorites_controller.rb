module Api
  module V1
    class FavoritesController < ApplicationController
      before_action :find_favorite, only: [:show, :update, :destroy]

      def index
        favs = Favorite.where(query_params)
        favs = sort_and_clean_results(favs)
        render json: favs
      end

      def show
        render json: @favorite
      end

      def create
        if @favorite.present?
          head :no_content, status: :conflict
        else
          @favorite = Favorite.new
          @favorite.assign_attributes(create_params)
          if @favorite.save
            render json: @favorite, status: :created
          else
            head :no_content, status: :bad_request
          end
        end
      end

      def destroy
        authorize @favorite
        @favorite.delete
        head :no_content, status: :no_content
      end

      private

      def sort_and_clean_results(favs)
        favs = JSON.parse(favs.to_json)
        favs = favs.map(&:compact)
        results = {locations: [], images: [], items: [], reviews: []}
        favs.each do |fav|
          results[:locations] << fav["location_id"] if fav.has_key? "location_id"
          results[:reviews] << fav["review_id"] if fav.has_key? "review_id"
          results[:items] << fav["item_id"] if fav.has_key? "item_id"
          results[:images] << fav["image_id"] if fav.has_key? "image_id"
        end
        results
      end
      
      def find_favorite
        @favorite = Favorite.find(params[:id])
      end

      def create_params
        params[:user_id] = session[:current_user][:id]
        params.permit(:review_id, :item_id, :location_id, :user_id)
      end

      def query_params
        params.permit(:location_id, :user_id, :item_id, :review_id, :image_id)
      end
    end
  end
end
