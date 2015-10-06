class ProfileController < ApplicationController
  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to root_path, notice: "Профиль пользователя успешно обновлен"
    else
      flash.now.alert = "Сбой при обновлении профиля пользователя"
      render :edit
    end
  end

  private
    def profile_params
      params.require(:profile).permit(:email, :password, :password_confirmation, :current_pack_id)
    end
end
