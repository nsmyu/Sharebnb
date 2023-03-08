# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    super
  end

  def create
    super
    flash[:notice] = "アカウント登録が完了しました。次はプロフィールを編集してみましょう！"
  end

  def account
    @user = User.find(current_user.id)
  end

  def edit
    super
  end

  def profile
    @user = User.find(current_user.id)
  end

  def profile_edit
    @user = User.find(current_user.id)
  end

  def update_resource(resource, params)
    if params.has_key?(:current_password)
      resource.update_with_password(params)
    else
      resource.update_without_current_password(params)
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      if account_update_params[:current_password]
        flash.now[:alert] = "アカウント情報が更新できませんでした。"
        render "edit"
      else
        flash.now[:alert] = "プロフィールが更新できませんでした。"
        render "profile_edit"
      end
    end
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :introduction])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    users_profile_path
  end

  def after_update_path_for(resource)
    if account_update_params[:current_password]
      flash[:notice] = "アカウント情報を更新しました。"
      users_account_path
    else
      flash[:notice] = "プロフィールを更新しました。"
      users_profile_path
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
