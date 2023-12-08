class ChangeTaxAmountTypeInOrders < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :tax_amount, :decimal, precision: 10, scale: 2
  end
end