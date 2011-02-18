class CreateGigsMentors < ActiveRecord::Migration
  def self.up
    create_table :gigs_mentors, :id => false do |t|
      t.integer :gig_id
      t.integer :mentor_id
    end
  end

  def self.down
    drop_table :gigs_mentors
  end
end
