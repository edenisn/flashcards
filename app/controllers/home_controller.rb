class HomeController < ApplicationController
  def index
    @card = Card.get_random_card(DateTime.now).first
  end

  def examine
    @card = Card.find(params[:card_id])

    if @card.verify_translate(params[:original], @card.original_text)
      @card.update_attributes(review_date: @card.review_date)
      redirect_to :back, notice: "Правильно"
    else
      redirect_to :back, notice: "Не правильно!"
    end
  end
end
