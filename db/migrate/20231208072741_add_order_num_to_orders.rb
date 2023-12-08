class AddOrderNumToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :order_num, :string
  end
end
