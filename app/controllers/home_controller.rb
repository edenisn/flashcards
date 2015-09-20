class HomeController < ApplicationController
  def index
    @card = Card.for_review # get random card for review
  end

  def examine
    @card = Card.find(params[:card_id])

    if @card.verify_translating(params[:original])
      redirect_to :back, notice: "Правильно"
    else
      redirect_to :back, notice: "Не правильно!"
    end
  end
end
