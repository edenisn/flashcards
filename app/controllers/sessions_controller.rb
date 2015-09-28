class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(session_params[:email], session_params[:password])
      redirect_back_or_to root_url, notice: "Добро пожаловать!"
    else
      flash.now.alert = 'Неверный email или пароль'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, notice: "До свидания!"
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
