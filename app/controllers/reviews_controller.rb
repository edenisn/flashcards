class ReviewsController < ApplicationController
  def new
    @card = Card.for_review.first # get random card for review
  end

  def create
    @card = Card.find(review_params[:card_id])

    if @card.verify_translation(review_params[:user_translation])
      redirect_to :back, notice: "Правильно"
    else
      redirect_to :back, notice: "Не правильно!"
    end
  end

  private
    def review_params
      params.require(:review).permit(:card_id, :user_translation)
    end
end
