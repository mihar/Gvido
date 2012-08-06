class SplitDateOfBirthInPeople < ActiveRecord::Migration
  def up
    add_column :people, :day_of_birth, :integer
    add_column :people, :month_of_birth, :integer
    add_column :people, :year_of_birth, :integer

    Person.update_all "day_of_birth=DAYOFMONTH(date_of_birth), month_of_birth = MONTH(date_of_birth), year_of_birth=YEAR(date_of_birth)"
  end

  def down
    remove_column :people, :day_of_birth, :integer
    remove_column :people, :month_of_birth, :integer
    remove_column :people, :year_of_birth, :integer
  end
end
