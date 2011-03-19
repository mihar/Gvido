class PreparePeopleForPaymentOrders < ActiveRecord::Migration
  def self.up
    add_column :people, :reference_number,    :string  
    add_column :people, :billing_option_id,   :integer
    add_column :people, :student_id,          :integer
    rename_column :people, :sign_up_status, :status_id
    
    add_column :people, :type,                :string
    remove_column :people, :student
    remove_column :people, :mother_id
    remove_column :people, :father_id
    
    
    create_table :billing_options do |t|
      t.text    :description
      t.string  :short_description
    end
    
    create_table :statuses do |t|
      t.text    :description
      t.string  :short_description
    end
  end

  def self.down
    remove_column :people, :reference_number
    remove_column :people, :billing_option_id
    remove_column :people, :student_id
    rename_column :people, :status_id, :sign_up_status
    remove_column :people, :type
    add_column :people, :student,   :boolean, :default => false
    add_column :people, :mother_id, :integer
    add_column :people, :father_id, :integer
    drop_table :billing_options
    drop_table :statuses
  end
end
