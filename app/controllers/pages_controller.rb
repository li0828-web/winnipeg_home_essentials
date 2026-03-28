class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  
  def show
    @page = Page.find_by(slug: params[:slug])
    
    if @page.nil?
      redirect_to root_path, alert: "Page not found"
    end
  end
end
