class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :admin, :default => false
      t.database_authenticatable :null => false
      t.rememberable
      t.trackable

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    
    u = User.new(:first_name => "Tomaž", :last_name => "Pačnik", :email => "tomaz.pacnik@gvido.si", :password => "roland2000", :password_confirmation => "roland2000", :admin => true)
    u.save
    u = User.new(:first_name => "Ljubomir", :last_name => "Marković", :email => "ljm@disru.pt", :password => "ljmljm", :password_confirmation => "ljmljm", :admin => true)
    u.save
    u = User.new(:first_name => "Miha", :last_name => "Rebernik", :email => "mre@disru.pt", :password => "mremre", :password_confirmation => "mremre", :admin => true)
    u.save
  end

  def self.down
    drop_table :users
  end
end
