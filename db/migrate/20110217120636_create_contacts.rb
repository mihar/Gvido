class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :email
      t.text :text
      t.string :name
      t.string :address
      t.string :phone
      t.string :experience

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
