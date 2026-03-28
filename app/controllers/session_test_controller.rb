class SessionTestController < ApplicationController
  skip_before_action :authenticate_user!
  
  def index
    session[:test_count] ||= 0
    session[:test_count] += 1
    session[:cart] ||= {}
    session[:cart]["test"] = session[:test_count]
    
    render plain: "Session ID: #{session.id}\nTest Count: #{session[:test_count]}\nCart: #{session[:cart].inspect}\n\nRefresh this page to see count increase!"
  end
  
  def reset
    reset_session
    render plain: "Session reset! Go back to /session_test"
  end
end
