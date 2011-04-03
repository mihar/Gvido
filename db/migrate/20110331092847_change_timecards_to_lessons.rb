class ChangeTimecardsToLessons < ActiveRecord::Migration
  def self.up
    rename_table :time_cards, :lessons
    add_column :lessons, :mentor_id, :integer
    add_column :lessons, :student_id, :integer
  end

  def self.down
    remove_column :lessons, :mentor_id
    remove_column :lessons, :student_id
    rename_table :lessons, :time_cards
  end
end
