ActiveAdmin.register Customer do
  permit_params :first_name, :last_name, :password, :email, :address, :phone, :province_id
  index do
    column :id
    column :first_name
    column :last_name
    column :email
    column :address
    column :phone
    column :province
    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :password
      row :email
      row :address
      row :phone
      row :province
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :password
      f.input :email
      f.input :address
      f.input :phone
      f.input :province
    end
    f.actions
  end
end
