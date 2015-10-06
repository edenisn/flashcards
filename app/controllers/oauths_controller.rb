class OauthsController < ApplicationController
  skip_before_action :require_login
  before_action :require_login, only: :destroy

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if @user = login_from(provider)
      redirect_to root_path, notice: "Вы вошли в #{provider.titleize}"
    else
      begin
        @user = create_from(provider)

        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to root_path, notice: "Вы вошли в #{provider.titleize}"
      rescue
        redirect_to root_path, notice: "Ошибка при входе в Ваш #{provider.titleize} аккаунт"
      end
    end

  end

  def destroy
    provider = auth_params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:notice] = "Вы успешно вышли из Вашего #{provider.titleize} аккаунта"
    else
      flash[:alert] = "Возникли проблемы при выходе из Вашего #{provider.titleize} аккаунта"
    end

    redirect_to root_path
  end


  private
    def auth_params
      params.permit(:code, :provider)
    end
end
