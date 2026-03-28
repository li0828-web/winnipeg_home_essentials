module CartHelper
  def current_cart
    session[:cart] ||= {}
  end
  
  def add_to_cart(product_id, name, price, quantity = 1)
    session[:cart] ||= {}
    if session[:cart][product_id.to_s]
      session[:cart][product_id.to_s]['quantity'] += quantity
    else
      session[:cart][product_id.to_s] = {
        'id' => product_id,
        'name' => name,
        'price' => price.to_f,
        'quantity' => quantity
      }
    end
  end
  
  def remove_from_cart(product_id)
    session[:cart]&.delete(product_id.to_s)
  end
  
  def clear_cart
    session[:cart] = {}
  end
  
  def cart_items
    session[:cart] ||= {}
    session[:cart].values
  end
  
  def cart_subtotal
    cart_items.sum { |item| item['price'] * item['quantity'] }
  end
  
  def cart_total_items
    cart_items.sum { |item| item['quantity'] }
  end
  
  def cart_empty?
    cart_items.empty?
  end
end
