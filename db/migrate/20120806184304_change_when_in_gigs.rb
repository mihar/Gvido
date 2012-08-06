class ChangeWhenInGigs < ActiveRecord::Migration
  def change
    rename_column :gigs, :when, :happening_at
  end
end
