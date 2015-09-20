class ReviewsController < ApplicationController
  def new
    @card = Card.for_review.first # get random card for review
  end

  def create
    @card = Card.find(params[:review_params_card_id])

    if @card.verify_translating(params[:review_params_original])
      redirect_to :back, notice: "Правильно"
    else
      redirect_to :back, notice: "Не правильно!"
    end
  end
end
