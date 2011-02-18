class CreateGigs < ActiveRecord::Migration
  def self.up
    create_table :gigs do |t|
      t.string :title
      t.string :venue
      t.string :address
      t.text :description
      t.datetime :when

      t.timestamps
    end
  end

  def self.down
    drop_table :gigs
  end
end
