class PacksController < ApplicationController
  before_action :find_pack, only: [:show, :edit, :update, :destroy]

  def index
    @packs = current_user.packs.all
  end

  def new
    @pack = current_user.packs.new
  end

  def create
    if current_user.packs.current_and_true && pack_params[:current] == "true"
      flash[:notice] = "Извините, но уже есть текущая колода"
      redirect_to packs_path
    else
      @pack = current_user.packs.new(pack_params)

      if @pack.save
        redirect_to @pack, notice: "Колода успешно создана"
      else
        render 'new'
      end
    end
  end

  def update
    if current_user.packs.current_and_true && pack_params[:current] == "true"
      flash[:notice] = "Извините, но уже есть текущая колода"
      redirect_to packs_path
    else
      if @pack.update(pack_params)
        redirect_to @pack, notice: "Колода успешно обновлена"
      else
        render 'edit'
      end
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
      params.require(:pack).permit(:name, :current)
    end

    def find_pack
      @pack = current_user.packs.find(params[:id])
    end
end
