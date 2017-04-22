class CreateUsages < ActiveRecord::Migration[5.0]
  def change
    create_table :usages do |t|
      t.string :feedId
      t.datetime :timestamp
      t.integer :power

      t.timestamps
    end
  end
end
