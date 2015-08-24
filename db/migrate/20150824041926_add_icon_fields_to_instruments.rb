class AddIconFieldsToInstruments < ActiveRecord::Migration
  def change
    add_column :instruments, :icon_file_name, :string
    add_column :instruments, :icon_content_type, :string
    add_column :instruments, :icon_file_size, :integer
    add_column :instruments, :icon_updated_at, :datetime
  end
end
