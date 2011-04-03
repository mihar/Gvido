class CreateTimeCards < ActiveRecord::Migration
  def self.up
    create_table :time_cards do |t|
      t.integer :payment_id
      t.integer :lessons_per_month, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :time_cards
  end
end
