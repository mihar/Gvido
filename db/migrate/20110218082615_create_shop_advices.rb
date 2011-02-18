class CreateShopAdvices < ActiveRecord::Migration
  def self.up
    create_table :shop_advices do |t|
      t.string :url
      t.text :description
      t.integer :instrument_id
      t.string :photo_file_name
      t.integer :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :shop_advices
  end
end
