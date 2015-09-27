class ProfileController < ApplicationController
  before_action :find_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to root_path, notice: "Профиль пользователя успешно обновлен"
    else
      flash.now.alert = "Сбой в обновлении профиля пользователя"
      render :edit
    end
  end

  private
    def profile_params
      params.require(:profile).permit(:email)
    end

    def find_user
      @user = current_user
    end
end
