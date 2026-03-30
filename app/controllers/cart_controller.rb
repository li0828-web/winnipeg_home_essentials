class CartController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :add, :remove, :update, :clear, :test_add]

  def show
    @cart = session[:cart] || {}
    @cart_items = []
    @total = 0

    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
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

  def test_add
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    session[:cart] ||= {}
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += quantity

    redirect_to cart_path, notice: "Product added to cart!"
  end

  def add
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    product = Product.find_by(id: product_id)
    unless product
      redirect_to cart_path, alert: "Product not found!" and return
    end

    session[:cart] ||= {}
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += quantity

    redirect_to cart_path, notice: "Product added to cart!"
  end

  def remove
    product_id = params[:product_id].to_s
    session[:cart] ||= {}
    session[:cart].delete(product_id)
    redirect_to cart_path, notice: "Product removed from cart!"
  end

  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    session[:cart] ||= {}

    if quantity <= 0
      session[:cart].delete(product_id)
    else
      session[:cart][product_id] = quantity
    end

    redirect_to cart_path, notice: "Cart updated!"
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: "Cart cleared!"
  end
end
