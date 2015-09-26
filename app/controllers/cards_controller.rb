class CardsController < ApplicationController
  before_action :find_card, only: [:show, :edit, :update, :destroy]
  before_action :find_user, only: [:index, :new, :create]

  def index
    @cards = @user.cards.all
  end

  def new
    @card = @user.cards.new
  end

  def create
    @card = @user.cards.new(card_params)

    if @card.save
      redirect_to @card, notice: "Карточка успешно создана"
    else
      render 'new'
    end
  end

  def update
    if @card.update(card_params)
      redirect_to @card, notice: "Карточка успешно обновлена"
    else
      render 'edit'
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @card.destroy

    redirect_to cards_path
  end

  private
    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date)
    end

    def find_card
      @card = find_user.cards.find(params[:id])
    end

    def find_user
      @user = current_user
    end
end
