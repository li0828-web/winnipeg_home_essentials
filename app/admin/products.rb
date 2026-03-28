ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity
  
  index do
    selectable_column
    id_column
    column :name
    column :description do |product|
      truncate(product.description, length: 50) if product.description
    end
    column :price
    column :stock_quantity
    column :created_at
    actions
  end
  
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description, as: :text
      f.input :price
      f.input :stock_quantity
    end
    f.actions
  end
  
  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :created_at
      row :updated_at
    end
  end
  
  filter :name
  filter :price
  filter :stock_quantity
  filter :created_at
end
