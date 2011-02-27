class ChangeZipToPostOfficeIdInLocations < ActiveRecord::Migration
  def self.up
    rename_column :locations, :zip, :post_office_id
  end

  def self.down
    rename_column :locations, :post_office_id, :zip
  end
end
