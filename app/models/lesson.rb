class Lesson < ActiveRecord::Base
  belongs_to :payment
  belongs_to :student
  belongs_to :mentor
  
  class << self
    def on_date(date)
      where(:check_in_date => date)
    end
    
    def with_mentor(mentor_id)
      where(:mentor_id => mentor_id)
    end
    
    def all_months_for_mentor(mentor_id)
       if Mentor.find(mentor_id)
         return self.find_by_sql("SELECT DISTINCT check_in_date FROM lessons WHERE mentor_id = #{mentor_id} AND check_in_date <= LAST_DAY(CURDATE()) ORDER BY check_in_date ASC").map(&:check_in_date).group_by {|lessons_check_in_date| lessons_check_in_date.year}
       end
       return []
     end
  end
end
