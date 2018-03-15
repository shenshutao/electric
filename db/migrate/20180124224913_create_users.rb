class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :feedId
      t.string :apiKey
      t.string :passwordKey
      t.float :price
      t.string :groupNum
      t.string :goal
      t.string :lastname
      t.string :whatsapp
      t.string :email
      t.string :locale

      t.timestamps
    end
  end
end
