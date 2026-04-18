ActiveAdmin.register Order do
  permit_params :status, :user_id, :province_id, :subtotal, :tax, :total,
                order_items_attributes: [:id, :product_id, :quantity, :unit_price, :total_price, :_destroy]

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :subtotal
    column :tax
    column :total
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :subtotal
      row :tax
      row :total
      row :province
      row :created_at
    end

    panel "Products in this Order" do
      table_for order.order_items do
        column "Product" do |item|
          link_to item.product.name, admin_product_path(item.product)
        end
        column :quantity
        column "Unit Price" do |item|
          number_to_currency(item.unit_price)
        end
        column "Total" do |item|
          number_to_currency(item.total_price)
        end
      end
    end
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :user
      f.input :status, as: :select, collection: Order.statuses.keys.map { |s| [s.humanize, s] }
      f.input :province
      f.input :subtotal
      f.input :tax
      f.input :total
    end

    f.inputs "Products" do
      f.has_many :order_items, heading: "Order Items", allow_destroy: true do |item|
        item.input :product, collection: Product.all.map { |p| [p.name, p.id] }
        item.input :quantity
        item.input :unit_price
        item.input :total_price
      end
    end

    f.actions
  end
end
