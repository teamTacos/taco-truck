module Api
  module V1
    class ReviewsController < ApplicationController
      before_action :find_review, only: [:show, :update, :destroy]

      def index
        render json: Review.where(query_params)
      end

      def show
        render json: @review
      end

      def create
        if @review.present?
          head :no_content, status: :conflict
        else
          @review = Review.new
          @review.assign_attributes(create_params)
          if @review.save
            render json: @review, status: :created
          else
            head :no_content, status: :bad_request
          end
        end
      end

      def update
        authorize @review
        @review.update_attributes(update_params)
        if @review.save
          render json: @review, status: :no_content
        else
          head :no_content, status: :bad_request
        end
      end

      def destroy
        authorize @review
        @review.remove_images
        @review.delete
        head :no_content, status: :no_content
      end

      private

      def find_review
        @review = Review.find(params[:id])
      end

      def update_params
        params.require(:item_id)
        params.permit(:description, :rating, :item_id)
      end

      def create_params
        params[:user_id] = session[:current_user][:id]
        params.require(:item_id)
        params.require(:rating)
        params.require(:description)
        params.permit(:description, :rating, :item_id, :user_id)
      end

      def query_params
        params.permit(:item_id, :user_id)
      end
    end
  end
end
