class RemoveEmailandPassFromCustomers < ActiveRecord::Migration[7.0]
  def change
    remove_column :customers, :password
    remove_column :customers, :email
  end
end
