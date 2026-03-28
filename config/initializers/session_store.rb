# Use cookie store for sessions
Rails.application.config.session_store :cookie_store, 
  key: '_winnipeg_home_essentials_session',
  expire_after: 2.weeks,
  httponly: true,
  same_site: :lax
