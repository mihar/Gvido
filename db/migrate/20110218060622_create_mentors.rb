class CreateMentors < ActiveRecord::Migration
  def self.up
    create_table :mentors do |t|
      t.string :name
      t.string :surname
      t.string :phone
      t.string :email
      t.string :address
      t.string :photo
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.text :about
      t.string :permalink
      t.integer :position
      t.string :facebook
      t.string :myspace

      t.timestamps
    end
  end

  def self.down
    drop_table :mentors
  end
end
