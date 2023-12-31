ActiveAdmin.register Order do
  permit_params :customer_id, :order_date, :total, :tax_amount, :order_num

  index do
    selectable_column
    id_column
    column :customer
    column :order_date
    column :total
    column :tax_amount
    column :order_num
    actions
  end

  form do |f|
    f.inputs 'Order Details' do
      f.input :customer
      f.input :order_date
      f.input :total
      f.input :tax_amount
    end
    f.actions
  end
end
