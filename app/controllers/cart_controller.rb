class CartController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :add, :remove, :update, :clear, :test_add]
  
  def show
    @cart = session[:cart] || {}
    Rails.logger.info "=== CART SHOW ==="
    Rails.logger.info "Cart contents: #{@cart.inspect}"
    
    @cart_items = []
    @total = 0
    
    @cart.each do |product_id, quantity|
      if product_id.to_s.match?(/^\d+$/)
        product = Product.find_by(id: product_id.to_i)
        if product
          item_total = product.price * quantity
          @cart_items << {
            product: product,
            quantity: quantity,
            item_total: item_total
          }
          @total += item_total
        end
      end
    end
  end
  
  def test_add
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1
    
    Rails.logger.info "=== TEST ADD via GET ==="
    Rails.logger.info "Product ID: #{product_id}, Quantity: #{quantity}"
    
    # Get current cart or empty hash
    cart = session[:cart] || {}
    
    # Add product
    cart[product_id] ||= 0
    cart[product_id] += quantity
    
    # Save back to session
    session[:cart] = cart
    
    Rails.logger.info "Cart after save: #{session[:cart].inspect}"
    
    redirect_to cart_path, notice: "Product added to cart!"
  end
  
  def add
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1
    
    Rails.logger.info "=== CART ADD START ==="
    Rails.logger.info "Product ID: #{product_id}, Quantity: #{quantity}"
    
    product = Product.find_by(id: product_id)
    if product.nil?
      redirect_to cart_path, alert: "Product not found!" and return
    end
    
    cart = session[:cart] || {}
    cart[product_id] ||= 0
    cart[product_id] += quantity
    
    session[:cart] = cart
    
    Rails.logger.info "Cart now: #{session[:cart].inspect}"
    
    redirect_to cart_path, notice: "Product added to cart!"
  end
  
  def remove
    product_id = params[:product_id].to_s
    cart = session[:cart] || {}
    cart.delete(product_id)
    session[:cart] = cart
    redirect_to cart_path, notice: "Product removed from cart!"
  end
  
  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    cart = session[:cart] || {}
    
    if quantity <= 0
      cart.delete(product_id)
    else
      cart[product_id] = quantity
    end
    
    session[:cart] = cart
    redirect_to cart_path, notice: "Cart updated!"
  end
  
  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: "Cart cleared!"
  end
end
class CartController < ApplicationController
  def show
    @cart = session[:cart] || {}
  end
end
