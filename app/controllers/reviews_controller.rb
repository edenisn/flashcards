class ReviewsController < ApplicationController
  before_action :find_user, only: [:new, :create]

  def new
    @card = @user.cards.for_review.first # get random card for review
    unless @card
      render :new, notice: "Открывайте тренировщик позже"
    end
  end

  def create
    @card = @user.cards.find(review_params[:card_id])

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

    def find_user
      @user = current_user
    end
end
