class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.text :caption
      t.integer :comments_count
      t.string :likes_count
      t.string :integer
      t.integer :owner_id

      t.timestamps
    end
  end
end
