class CreateAbouts < ActiveRecord::Migration
  def self.up
    create_table :abouts do |t|
      t.text :text
      t.text :contact

      t.timestamps
    end
  end

  def self.down
    drop_table :abouts
  end
end
