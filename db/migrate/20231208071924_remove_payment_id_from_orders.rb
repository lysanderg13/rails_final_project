class RemovePaymentIdFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :payment_id, :string
  end
end