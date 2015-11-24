module Api
  module V1
    class ReviewsController < ApplicationController
      before_filter :find_review, only: [:show, :update, :destroy]

      def index
        render json: Item.where(item_id: params[:item_id])
      end

      def show
        render json: @review
      end

      def create
        if @review.present?
          render nothing: true, status: :conflict
        else
          @review = Review.new
          @review.assign_attributes(review_params)
          if @review.save
            render json: @review
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def update
        @review.assign_attributes(review_params)
        if @review.save
          render json: @review
        else
          render nothing: true, status: :bad_request
        end
      end

      def destroy
        @review.delete
        render nothing: true
      end

      private

      def find_item
        @review = Review.find(params[:id])
      end

      def item_params
        params.permit(:description, :rating, :item_id)
      end

    end
  end
end
