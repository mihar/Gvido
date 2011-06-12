class DropPaymentsTableIfItExists < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS payments"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
