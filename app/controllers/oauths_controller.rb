class OauthsController < ApplicationController
  skip_before_action :require_login
  before_action :require_login, only: :destroy

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if @user = login_from(provider)
      redirect_to root_path, notice: "Вошли в #{provider.titleize}!"
    else
      if logged_in?
        link_account(provider)
        redirect_to root_path
      else
        redirect_to login_path, notice: "Вы сначала должны войти на сайт, а потом уже кликать по ссылке 'Войти в #{provider.titleize}!'"
      end
    end

  end

  def destroy
    provider = params[:provider]

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
    def link_account(provider)
      if @user = add_provider_to_user(provider)
        # If you want to store the user's Github login, which is required in order to interact with their Github account, uncomment the next line.
        # You will also need to add a 'github_login' string column to the registrations table.
        #
        # @user.update_attribute(:github_login, @user_hash[:user_info]['login'])
        flash[:notice] = "Вы успешно вошли в Ваш #{provider.titleize} аккаунт"
      else
        flash[:alert] = "Возникли проблемы при входе в Ваш #{provider.titleize} аккаунт"
      end
    end

    def auth_params
      params.permit(:code, :provider)
    end
end
