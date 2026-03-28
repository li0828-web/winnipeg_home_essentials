class Admin::BaseController < ActiveAdmin::BaseController
  include Devise::Controllers::Helpers
  
  before_action :authenticate_admin_user!
  
  def authenticate_admin_user!
    authenticate_user!
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied"
    end
  end
  
  def current_admin_user
    current_user if current_user&.admin?
  end
  helper_method :current_admin_user
end
