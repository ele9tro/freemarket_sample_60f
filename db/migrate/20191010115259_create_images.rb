class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :img, null:false
      t.references :product, null:false, foreign_key: true
      t.timestamps
    end
  end
end
