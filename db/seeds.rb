# Create admin user
User.find_or_create_by!(email: 'admin@winnipegessentials.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.admin = true
end

# Create provinces with tax rates
provinces = [
  { name: "Alberta", code: "AB", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "British Columbia", code: "BC", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00 },
  { name: "Manitoba", code: "MB", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00 },
  { name: "New Brunswick", code: "NB", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Newfoundland and Labrador", code: "NL", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Northwest Territories", code: "NT", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "Nova Scotia", code: "NS", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Nunavut", code: "NU", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "Ontario", code: "ON", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.13 },
  { name: "Prince Edward Island", code: "PE", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Quebec", code: "QC", gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.00 },
  { name: "Saskatchewan", code: "SK", gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.00 },
  { name: "Yukon", code: "YT", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 }
]

provinces.each do |province|
  Province.find_or_create_by!(code: province[:code]) do |p|
    p.name = province[:name]
    p.gst_rate = province[:gst_rate]
    p.pst_rate = province[:pst_rate]
    p.hst_rate = province[:hst_rate]
  end
end

# Create categories
categories = [
  { name: "Kitchen", description: "Kitchenware and cooking essentials" },
  { name: "Home Decor", description: "Decorative items for your home" },
  { name: "Storage", description: "Storage solutions" },
  { name: "Bath", description: "Bathroom accessories" }
]

categories.each do |cat|
  Category.find_or_create_by!(name: cat[:name]) do |c|
    c.description = cat[:description]
  end
end

# Create products
products = [
  { name: "Stainless Steel Frying Pan", description: "12-inch non-stick frying pan with heat-resistant handle", price: 39.99, stock_quantity: 25 },
  { name: "Ceramic Coffee Mug Set", description: "Set of 4 handmade ceramic mugs in assorted colors", price: 29.99, stock_quantity: 40 },
  { name: "Bamboo Cutting Board", description: "Large eco-friendly bamboo cutting board with juice groove", price: 24.99, stock_quantity: 30 },
  { name: "Glass Storage Container Set", description: "10-piece airtight glass food storage containers", price: 49.99, stock_quantity: 20 },
  { name: "Memory Foam Bath Mat", description: "Plush memory foam bath mat, machine washable", price: 34.99, stock_quantity: 35 },
  { name: "Decorative Throw Pillow", description: "18x18 inch velvet throw pillow with tassel corners", price: 29.99, stock_quantity: 50 },
  { name: "Kitchen Knife Set", description: "6-piece stainless steel chef knife set with wooden block", price: 89.99, stock_quantity: 15 },
  { name: "LED Floor Lamp", description: "Modern adjustable LED floor lamp with remote control", price: 79.99, stock_quantity: 12 },
  { name: "Cotton Bath Towel Set", description: "6-piece premium cotton bath towel set, charcoal grey", price: 59.99, stock_quantity: 28 },
  { name: "Wall Art Canvas", description: "Large abstract canvas wall art, 24x36 inches", price: 69.99, stock_quantity: 10 }
]

products.each do |product|
  Product.find_or_create_by!(name: product[:name]) do |p|
    p.description = product[:description]
    p.price = product[:price]
    p.stock_quantity = product[:stock_quantity]
  end
end

# Assign categories to products
kitchen = Category.find_by(name: "Kitchen")
home_decor = Category.find_by(name: "Home Decor")
storage = Category.find_by(name: "Storage")
bath = Category.find_by(name: "Bath")

Product.all.each_with_index do |product, index|
  if product.category.nil?
    case index % 4
    when 0
      product.update(category: kitchen)
    when 1
      product.update(category: home_decor)
    when 2
      product.update(category: storage)
    when 3
      product.update(category: bath)
    end
  end
end

puts "✅ Admin: admin@winnipegessentials.com / password123"
puts "✅ #{Province.count} provinces seeded"
puts "✅ #{Category.count} categories"
puts "✅ #{Product.count} products"
# Add more products for testing
Product.create!(name: 'Winter Blanket', description: 'Warm cozy blanket', price: 49.99, stock_quantity: 20)
Product.create!(name: 'Hot Chocolate Set', description: 'Premium hot chocolate mix', price: 24.99, stock_quantity: 30)
