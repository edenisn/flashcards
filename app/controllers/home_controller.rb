class HomeController < ApplicationController
  def index
    @card = Card.created_before(DateTime.now).random.first
  end

  def examine
    @card = Card.find(params[:id])

    if @card.verify_translate(params[:original], params[:translated])
      @card.update_attributes(review_date: params[:date])
      redirect_to :back, notice: "Правильно"
    else
      redirect_to :back, notice: "Не правильно!"
    end
  end
end
