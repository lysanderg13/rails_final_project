class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_customer_name, if: :customer_signed_in?

  def set_customer_name
    @customer_name = current_customer.email
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[first_name last_name address phone province_id])
  end
end
