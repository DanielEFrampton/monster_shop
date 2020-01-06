class AddDisabledToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :disabled, :boolean, default: false
  end
end
