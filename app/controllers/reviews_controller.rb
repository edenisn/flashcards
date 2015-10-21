class ReviewsController < ApplicationController
  def new
    @card = current_user.review_cards.first
  end

  def create
    @card = current_user.cards.find(review_params[:card_id])

    translation_result = @card.verify_translation(review_params[:user_translation],
                                                  review_params[:translate_time])

    if translation_result
      redirect_to :back, notice: t('views.reviews.flash_messages.user_translated_correct')
    else
      redirect_to :back, notice: t('views.reviews.flash_messages.user_translated_incorrect')
    end
  end

  private
    def review_params
      params.require(:review).permit(:card_id, :translate_time, :user_translation)
    end
end
