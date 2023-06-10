class CreatePharmacyMasks < ActiveRecord::Migration[7.0]
  def change
    create_table :pharmacy_masks do |t|

      t.timestamps
      t.references :pharmacy, null: false, foreign_key: true
      t.references :mask, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, default: 0.0, null: false
    end
  end
end
