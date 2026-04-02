ActiveAdmin.register Province do
  permit_params :name, :code, :gst_rate, :pst_rate, :hst_rate

  index do
    selectable_column
    id_column
    column :name
    column :code
    column "GST" do |p|
      "#{(p.gst_rate * 100).to_i}%"
    end
    column "PST" do |p|
      "#{(p.pst_rate * 100).to_i}%" if p.pst_rate > 0
    end
    column "HST" do |p|
      "#{(p.hst_rate * 100).to_i}%" if p.hst_rate > 0
    end
    column "Tax Type" do |p|
      if p.hst_rate > 0
        "HST"
      elsif p.pst_rate > 0
        "GST + PST"
      else
        "GST only"
      end
    end
    actions
  end

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :code
      f.input :gst_rate, label: "GST Rate (e.g., 0.05 for 5%)", input_html: { step: 0.0001 }
      f.input :pst_rate, label: "PST Rate (e.g., 0.07 for 7%)", input_html: { step: 0.0001 }
      f.input :hst_rate, label: "HST Rate (e.g., 0.13 for 13%)", input_html: { step: 0.0001 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :code
      row "GST Rate" do |p|
        "#{(p.gst_rate * 100).to_i}%"
      end
      row "PST Rate" do |p|
        "#{(p.pst_rate * 100).to_i}%" if p.pst_rate > 0
      end
      row "HST Rate" do |p|
        "#{(p.hst_rate * 100).to_i}%" if p.hst_rate > 0
      end
      row "Total Tax Rate" do |p|
        "#{((p.gst_rate + p.pst_rate + p.hst_rate) * 100).to_i}%"
      end
      row :created_at
      row :updated_at
    end
  end
end
