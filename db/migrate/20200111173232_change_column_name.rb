class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :coupons, :percent, :percent_off
  end
end
