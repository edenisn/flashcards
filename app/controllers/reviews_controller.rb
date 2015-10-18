class ReviewsController < ApplicationController
  def new
    @card = current_user.review_cards.first
  end

  def create
    @card = current_user.cards.find(review_params[:card_id])

    translation_result = @card.verify_translation(review_params[:user_translation])

    if translation_result[:result]
      if translation_result[:typos] > 0
        flash[:notice] = t('views.reviews.flash_messages.user_translated_with_distance')
      else
        flash[:notice] = t('views.reviews.flash_messages.user_translated_correct')
      end
      redirect_to :back
    else
      redirect_to :back, notice: t('views.reviews.flash_messages.user_translated_incorrect')
    end
  end

  private
    def review_params
      params.require(:review).permit(:card_id, :user_translation)
    end
end
