class ReviewsController < ApplicationController
  def new
    @pack_current_true = current_user.packs.current_and_true.first
    review = @pack_current_true.cards.for_review.first # get random card for review

    if review # have cards for review from current pack
      @card = review
    else
      @card = current_user.cards.for_review.first
    end
  end

  def create
    @card = current_user.cards.find(review_params[:card_id])

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
