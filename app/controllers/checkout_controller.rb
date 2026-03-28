class CheckoutController < ApplicationController
  include CartHelper
  before_action :check_cart_not_empty
  before_action :get_cart_summary
  before_action :require_user, except: [:address, :create_customer]

  # Step 1: Show address form
  def address
    @customer = Customer.new
    @provinces = Province.all
  end

  # Step 2: Save customer and show invoice
  def create_customer
    @customer = Customer.new(customer_params)
    @customer.session_id = session.id.to_s

    if @customer.save
      session[:customer_id] = @customer.id
      if user_signed_in?
        # If logged in, create order immediately
        redirect_to checkout_invoice_path
      else
        # If not logged in, ask to sign up
        redirect_to new_user_registration_path, notice: "Please create an account to complete your order"
      end
    else
      @provinces = Province.all
      render :address
    end
  end

  # Step 3: Display invoice with taxes
  def invoice
    @customer = Customer.find(session[:customer_id])
    @cart_items = cart_items
    @subtotal = cart_subtotal

    # Find or create the province
    @province = Province.find_by(code: @customer.province) || Province.first

    # Calculate taxes
    tax_calculation = TaxCalculator.calculate(@subtotal, @province.code)

    # Create the order with user association
    @order = Order.new(
      user_id: current_user.id,
      province_id: @province.id,
      subtotal: @subtotal,
      tax: tax_calculation[:total_tax],
      total: tax_calculation[:total],
      status: :pending
    )

    if @order.save
      # Create order items
      @cart_items.each do |item|
        @order.order_items.create(
          product_id: item['id'],
          product_name: item['name'],
          quantity: item['quantity'],
          unit_price: item['price'],
          subtotal: item['price'] * item['quantity']
        )
      end

      # Clear the cart
      clear_cart
      session[:order_id] = @order.id
      session[:customer_id] = nil
      flash[:success] = "Order placed successfully!"
      redirect_to checkout_confirm_path
    else
      flash[:error] = "There was a problem processing your order. Please try again."
      redirect_to checkout_address_path
    end
  end

  # Step 4: Order confirmation
  def confirm
    @order = Order.find(session[:order_id])
    @customer = @order.user.customer || Customer.find_by(session_id: session.id.to_s)
  end

  private

  def check_cart_not_empty
    if cart_empty?
      flash[:error] = "Your cart is empty. Please add some items before checking out."
      redirect_to products_path
    end
  end

  def get_cart_summary
    @cart_item_count = cart_total_items
    @cart_subtotal = cart_subtotal
  end

  def require_user
    unless user_signed_in?
      redirect_to new_user_session_path, notice: "Please sign in to complete your order"
    end
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :address, :city, :province, :postal_code, :phone)
  end
end