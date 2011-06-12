class DropPaymentExceptionsTableIfItExists < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS payment_exceptions"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
