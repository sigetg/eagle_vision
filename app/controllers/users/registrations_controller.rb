# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource

  def create
    build_resource(sign_up_params)
    if data = fetch_data_from_api(resource.email)[0]
      resource.person_id = data['id']
      resource.typeKey = data['typeKey']
      resource.stateKey = data['stateKey']
      resource.name = data['name']
      resource.descr = data['descr']
      resource.pictureDocumentId = data['pictureDocumentId']
      resource.meta = data['meta']
      resource.person_email = data['person_email']
    end
    if resource.save && resource.person_email != nil
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def fetch_data_from_api(email)
    uri = URI("http://127.0.0.1:3000/people?person_email=#{email}")
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      # Process the API response and return the necessary data
      # For example: data['name'], data['age'], etc.
    else
      Rails.logger.error("API Error: #{response.code} - #{response.message}")
      nil
    end
  rescue StandardError => e
    Rails.logger.error("API Error: #{e.message}")
    nil
  end

    # If you have extra params to permit, append them to the sanitizer.

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:typeKey, :stateKey, :name, :descr, :pictureDocumentId, :meta, :person_email])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:typeKey, :stateKey, :name, :descr, :pictureDocumentId, :meta, :person_email])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
