ActiveAdmin.register Order do
  permit_params :status, :user_id, :province_id, :subtotal, :tax, :total

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :subtotal
    column :tax
    column :total
    column :province
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

    panel "Order Items" do
      table_for order.order_items do
        column "Product" do |item|
          item.product.name
        end
        column "Quantity" do |item|
          item.quantity
        end
        column "Unit Price" do |item|
          number_to_currency(item.unit_price)
        end
        column "Total Price" do |item|
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
    f.actions
  end
end
