class ProfileController < ApplicationController
  def edit
    current_user
  end

  def update
    if current_user.update(profile_params)
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
end
