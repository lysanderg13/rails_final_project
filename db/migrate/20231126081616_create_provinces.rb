class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :name
      t.decimal :tax_rate

      t.timestamps
    end

    add_reference :customers, :province, foreign_key: true
  end
end
