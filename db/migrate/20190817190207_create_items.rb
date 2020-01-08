class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.string :image, default: 'https://res.cloudinary.com/teepublic/image/private/s--jAfsTCc0--/t_Preview/b_rgb:42332c,c_limit,f_jpg,h_630,q_90,w_630/v1472219144/production/designs/651797_1.jpg'
      t.boolean :active?, default: true
      t.integer :inventory
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
