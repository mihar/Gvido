class CreatePostOffices < ActiveRecord::Migration
  def self.up
    create_table :post_offices, :id => false do |t|
      t.integer :id
      t.string :name
    end
  end

  def self.down
    drop_table :post_offices
  end
end
