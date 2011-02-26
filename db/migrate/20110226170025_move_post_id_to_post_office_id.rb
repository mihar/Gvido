class MovePostIdToPostOfficeId < ActiveRecord::Migration
  def self.up
    rename_column :people, :post_id, :post_office_id
  end

  def self.down
    rename_column :people, :post_office_id, :post_id
  end
end