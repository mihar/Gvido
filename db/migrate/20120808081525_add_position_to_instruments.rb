class AddPositionToInstruments < ActiveRecord::Migration
  def change
    add_column :instruments, :position, :integer, :default => 0
  end
end
