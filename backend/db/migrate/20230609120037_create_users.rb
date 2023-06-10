class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|

      t.timestamps
      t.string :name, null: false
      t.decimal :cash_balance, precision: 10, scale: 2, default: 0.0, null: false
      
    end
  end
end
