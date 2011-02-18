class CreateInstruments < ActiveRecord::Migration
  def self.up
    create_table :instruments do |t|
      t.string :title
      t.string :permalink
      t.text :description
      t.text :goals
      t.text :activities
      t.text :introduction
      t.text :shop_instructions

      t.timestamps
    end
  end

  def self.down
    drop_table :instruments
  end
end
