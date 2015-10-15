class PacksController < ApplicationController
  before_action :find_pack, only: [:show, :edit, :update, :destroy]

  def index
    @packs = current_user.packs.all
  end

  def new
    @pack = current_user.packs.new
  end

  def create
    @pack = current_user.packs.new(pack_params)

    if @pack.save
      redirect_to @pack, notice: t('views.packs.flash_messages.pack_was_successfully_created')
    else
      render 'new'
    end
  end

  def update
    if @pack.update(pack_params)
      redirect_to @pack, notice: t('views.packs.flash_messages.pack_was_successfully_updated')
    else
      render 'edit'
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @pack.destroy

    redirect_to packs_path
  end

  private
    def pack_params
      params.require(:pack).permit(:name)
    end

    def find_pack
      @pack = current_user.packs.find(params[:id])
    end
end
