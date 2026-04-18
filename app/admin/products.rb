ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :sale_price,
                category_ids: []

  index do
    selectable_column
    id_column
    column :name
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
      f.input :sale_price
    end

    f.inputs "Categories" do
      f.input :categories, as: :check_boxes, collection: Category.all.order(:name)
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :sale_price
      row :categories do |product|
        product.categories.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
  end
end
