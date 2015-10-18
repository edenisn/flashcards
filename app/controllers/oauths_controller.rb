class OauthsController < ApplicationController
  skip_before_action :require_login
  before_action :require_login, only: :destroy

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if @user = login_from(provider)
      redirect_to root_path, notice: t('oauth_user.user_successfully_login')
    else
      begin
        @user = create_from(provider)

        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to root_path, notice: t('oauth_user.user_successfully_login')
      rescue
        redirect_to root_path, notice: t('oauth_user.user_error_login')
      end
    end

  end

  def destroy
    provider = auth_params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:notice] = t('oauth_user.user_successfully_logout')
    else
      flash[:alert] = t('oauth_user.user_error_logout')
    end

    redirect_to root_path
  end


  private
    def auth_params
      params.permit(:code, :provider)
    end
end
