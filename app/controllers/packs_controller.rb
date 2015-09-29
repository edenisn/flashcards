class PacksController < ApplicationController
  before_action :find_pack, only: [:show, :edit, :update, :destroy]

  def index
    @packs = Pack.all
  end

  def new
    @pack = Pack.new
  end

  def create
    @pack = Pack.new(pack_params)

    if @pack.save
      redirect_to @pack, notice: "Колода успешно создана"
    else
      render 'new'
    end
  end

  def update
    if @pack.update(pack_params)
      redirect_to @pack, notice: "Колода успешно обновлена"
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
      params.require(:pack).permit(:name, :current)
    end

    def find_pack
      @pack = Pack.find(params[:id])
    end
end
