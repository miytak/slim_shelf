class CreateCds < ActiveRecord::Migration
  def change
    create_table :cds do |t|
      t.string :title, null: false
      t.string :ean, null: false
      t.string :jacket_image_url
      t.datetime :release_date
      t.datetime :having
      t.references :artist, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :cds, :title
    add_index :cds, :ean
  end
end
