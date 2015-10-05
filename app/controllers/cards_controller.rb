class CardsController < ApplicationController
  before_action :find_card, only: [:show, :edit, :update, :destroy]

  def index
    @cards = current_user.cards.all
  end

  def new
    @card = Card.new
  end

  def create
    @pack = current_user.packs.find(card_params[:pack_id])
    @card = @pack.cards.new(card_params)

    if @new_pack = @card.create_for_pack(current_user, params[:new_pack_name])
      Card.transaction do
        @card.save
        @new_pack.save
      end
      redirect_to @card, notice: "Карточка и колода успешно созданы"
    elsif @card.save
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
      params.require(:card).permit(:original_text, :translated_text, :review_date, :image, :pack_id)
    end

    def find_card
      @card = Card.find(params[:id])
    end
end
