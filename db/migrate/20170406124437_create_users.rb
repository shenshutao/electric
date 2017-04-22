class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :feedId
      t.string :apiKey
      t.string :passwordKey

      t.timestamps
    end
  end
end