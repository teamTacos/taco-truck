module Api
  module V1
    class ReviewsController < ApplicationController
      before_filter :find_review, only: [:show, :update, :destroy]

      def index
        render json: Review.where(item_id: params[:item_id])
      end

      def show
        render json: @review
      end

      def create
        if @review.present?
          render nothing: true, status: :conflict
        else
          @review = Review.new
          @review.assign_attributes(create_params)
          if @review.save
            render json: @review, status: :created
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def update
        @review.update_attributes(update_params)
        if @review.save
          render json: @review, status: :no_content
        else
          render nothing: true, status: :bad_request
        end
      end

      def destroy
        @review.delete
        render nothing: true, status: :no_content
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
        params.require(:item_id)
        params.require(:rating)
        params.require(:description)
        params.permit(:description, :rating, :item_id)
      end

    end
  end
end
