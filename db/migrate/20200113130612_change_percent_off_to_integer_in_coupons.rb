class ChangePercentOffToDecimalInCoupons < ActiveRecord::Migration[5.1]
  def change
    change_column :coupons, :percent_off, :integer
  end
end
