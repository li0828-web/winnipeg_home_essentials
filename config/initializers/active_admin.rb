ActiveAdmin.setup do |config|
  config.site_title = "Winnipeg Home Essentials"
  
  # Use Devise authentication
  config.authentication_method = :authenticate_user!
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_user_session_path
  config.logout_link_method = :delete
  
  config.comments = true
  config.batch_actions = true
  config.filters = true
  config.default_per_page = 30
end
