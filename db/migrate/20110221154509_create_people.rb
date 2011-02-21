class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.integer :post_id
      t.string :place
      t.string :mobile
      t.string :email
      t.string :landline

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
