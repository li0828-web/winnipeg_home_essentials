class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :require_cart_items

  def new
    @cart = session[:cart] || {}
    @cart_items = []
    @subtotal = 0

    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        item_total = product.price * quantity
        @cart_items << {
          product: product,
          quantity: quantity,
          item_total: item_total
        }
        @subtotal += item_total
      end
    end

    @provinces = Province.all.order(:name)
    @selected_province = current_user.province || Province.find_by(code: "MB")
    @tax = calculate_tax(@subtotal, @selected_province)
    @total = @subtotal + @tax
  end

  def create
    @cart = session[:cart] || {}

    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty" and return
    end

    province = Province.find(params[:province_id])

    if params[:address].present? && params[:city].present? && params[:postal_code].present?
      current_user.update(
        address: params[:address],
        city: params[:city],
        postal_code: params[:postal_code],
        province: province
      )
    elsif !current_user.has_address?
      flash[:alert] = "Please provide your address details"
      redirect_to checkout_path and return
    end

    subtotal = 0
    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      subtotal += product.price * quantity if product
    end

    tax = calculate_tax(subtotal, province)
    total = subtotal + tax

    order = current_user.orders.create!(
      status: :pending,
      subtotal: subtotal,
      tax: tax,
      total: total,
      province: province
    )

    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      order.order_items.create!(
        product: product,
        quantity: quantity,
        unit_price: product.price,
        total_price: product.price * quantity
      )

      product.update!(stock_quantity: product.stock_quantity - quantity)
    end

    session[:cart] = {}

    redirect_to order_path(order), notice: "Order placed successfully!"
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def require_cart_items
    if session[:cart].blank? || session[:cart].empty?
      redirect_to cart_path, alert: "Your cart is empty" and return
    end
  end

  def calculate_tax(subtotal, province)
    gst = subtotal * province.gst_rate
    pst = subtotal * province.pst_rate
    hst = subtotal * province.hst_rate
    (gst + pst + hst).round(2)
  end
end
