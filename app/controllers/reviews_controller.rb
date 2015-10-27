class ReviewsController < ApplicationController
  def new
    @card = current_user.review_cards.first
  end

  def create
    @card = current_user.cards.find(review_params[:card_id])

    respond_to do |format|
      if @result = @card.verify_translation(review_params[:user_translation], review_params[:translation_time])
        format.html {
          redirect_to :back,
          notice: t('views.reviews.flash_messages.user_translated_correct')
        }
        format.json { render json: @result }
      else
        format.html {
          redirect_to :back,
          notice: t('views.reviews.flash_messages.user_translated_incorrect')
        }
        format.json { render json: @result }
      end
    end
  end

  private
    def review_params
      params.require(:review).permit(:card_id, :translation_time, :user_translation)
    end
end
