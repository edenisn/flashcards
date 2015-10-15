class CardsController < ApplicationController
  before_action :find_card, only: [:show, :edit, :update, :destroy]

  def index
    @cards = current_user.cards.all
  end

  def new
    @card = Card.new
  end

  def create
    if @card = Card.create_from_pack(current_user, card_params)
      redirect_to @card, notice: t('views.cards.flash_messages.card_was_successfully_created')
    else
      render 'new'
    end
  end

  def update
    if @card.update_from_pack(current_user, card_params)
      redirect_to @card, notice: t('views.cards.flash_messages.card_was_successfully_updated')
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
      params.require(:card).permit(:original_text, :translated_text, :review_date,
                                   :image, :pack_id, :new_pack_name)
    end

    def find_card
      @card = Card.find(params[:id])
    end
end
