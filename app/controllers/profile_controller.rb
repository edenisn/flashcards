class ProfileController < ApplicationController
  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to root_path, notice: t('views.profile.flash_messages.user_profile_successfully_updated')
    else
      flash.now.alert = t('views.profile.flash_messages.user_profile_wrong_updated')
      render :edit
    end
  end

  private
    def profile_params
      params.require(:profile).permit(:email, :password, :password_confirmation,
                                      :current_pack_id, :locale)
    end
end
