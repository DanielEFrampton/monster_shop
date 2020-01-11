class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name, unique: true
      t.string :code, unique: true
      t.integer :percent
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
