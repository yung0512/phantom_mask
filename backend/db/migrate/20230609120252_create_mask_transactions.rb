class CreateMaskTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :mask_transactions do |t|
        
        t.timestamps
        t.datetime :purchase_at, null: false
        t.references :user, null: false, foreign_key: true
        t.references :pharmacy, null: false, foreign_key: true
        t.references :pharmacy_mask, null: false, foreign_key: true
        t.decimal :amount, precision: 10, scale: 2, default: 0.0, null: false
      end
  end
end
