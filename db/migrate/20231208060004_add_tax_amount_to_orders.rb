class AddTaxAmountToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :tax_amount, :integer
  end
end
