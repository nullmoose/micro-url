class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.text :original_url
      t.string :short_slug
      t.string :admin_slug
      t.integer :click_counter, default: 0
      t.boolean :expired, default: false

      t.timestamps
    end
    add_index :links, :short_slug
    add_index :links, :admin_slug
  end
end
