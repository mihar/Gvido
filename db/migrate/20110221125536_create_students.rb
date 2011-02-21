class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.integer :post_id
      t.string :place

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
