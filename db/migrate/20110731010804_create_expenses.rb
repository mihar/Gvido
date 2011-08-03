class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string :name
      t.decimal :amount
      t.integer :mentor_id
      t.datetime :incurred_at

      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
