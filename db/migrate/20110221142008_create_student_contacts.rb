class CreateStudentContacts < ActiveRecord::Migration
  def self.up
    create_table :student_contacts do |t|
      t.string :title
      t.string :address
      t.integer :post_id
      t.string :place
      t.string :mobile
      t.string :email
      t.string :landline
      t.string :student_id
    end
  end

  def self.down
    drop_table :student_contacts
  end
end
