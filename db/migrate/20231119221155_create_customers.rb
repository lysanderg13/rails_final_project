class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :password
      t.string :email
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
