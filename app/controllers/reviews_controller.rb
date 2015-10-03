class ReviewsController < ApplicationController
  def new
    if @current_pack = current_user.current_pack # user have current pack
      @card = @current_pack.cards.for_review.first # get random card for review from current pack
    end

    @card = current_user.cards.for_review.first
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
