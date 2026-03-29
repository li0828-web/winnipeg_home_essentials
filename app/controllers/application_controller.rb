class ApplicationController < ActionController::Base
  # Skip authentication for ActiveAdmin pages
  before_action :authenticate_user!, unless: :active_admin_request?
  
  def active_admin_request?
    request.path.start_with?('/admin')
  end
  
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      root_path
    end
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:address, :city, :postal_code, :province_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:address, :city, :postal_code, :province_id])
  end
end
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      root_path
    end
  end
  def after_sign_out_path_for(resource)
    root_path
  end
  def cart_count
    session[:cart]&.values&.sum || 0
  end
  helper_method :cart_count
