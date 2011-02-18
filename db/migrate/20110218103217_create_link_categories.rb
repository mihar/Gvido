class CreateLinkCategories < ActiveRecord::Migration
  def self.up
    create_table :link_categories, :id => false do |t|
      t.string :title
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :link_categories
  end
end
