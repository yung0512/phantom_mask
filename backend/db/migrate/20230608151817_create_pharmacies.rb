class CreatePharmacies < ActiveRecord::Migration[7.0]
  def change
    create_table :pharmacies do |t|

      t.timestamps
      t.string :name, null: false
      t.decimal :cash_balance, precision: 10, scale: 2, default: 0.0, null: false
      t.json :open_hours, null: false
    end
  end
end
