class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_to root_url, notice: t('views.registration.flash_messages.user_successfully_created')
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:registration).permit(:email, :password, :password_confirmation)
    end
end
