class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  
  def index
    products = Product.all
    
    case params[:filter]
    when 'new'
      products = products.new_products
      @active_filter = 'New Products'
    when 'recently_updated'
      products = products.recently_updated
      @active_filter = 'Recently Updated'
    when 'on_sale'
      products = products.on_sale
      @active_filter = 'On Sale'
    else
      @active_filter = 'All Products'
    end
    
    if params[:q].present?
      @q = products.ransack(params[:q])
      @products = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(6)
    else
      @q = Product.ransack
      @products = products.order(created_at: :desc).page(params[:page]).per(6)
    end
  end
  
  def show
    @product = Product.find(params[:id])
  end
end
  def index
    @products = Product.page(params[:page]).per(6)
  end
