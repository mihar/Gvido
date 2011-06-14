class MonthlyLesson < ActiveRecord::Base
  belongs_to :student
  belongs_to :enrollment
  belongs_to :mentor
  belongs_to :payment_period
  belongs_to :invoice
  
  validates_numericality_of :hours, :greater_than_or_equal_to => 0

  CHECK_IN_DATE_SPACER = 4

  class << self
    def on_date(_date)
      where(:date => _date)
    end
    
    def with_mentor(_mentor_id)
      where(:mentor_id => _mentor_id)
    end
    
    def on_date_with_mentor(_date, _mentor_id)
      lessons_on_date = MonthlyLesson.on_date(_date).with_mentor(_mentor_id).reload
    end
    
    def on_month_for_mentor(_date, _mentor_id)
      month, year = _date.month, _date.year
      self.where(:mentor_id => _mentor_id).where("MONTH(date) <= ?", month).where("YEAR(date) <= ?", year).reload
    end
    
    # Returns a hash of mentors check in dates up to now 
    # that looks something like this => #<OrderedHash {2011=>[Wed, 01 Jun 2011]}> 
    #
    def check_in_dates_for_mentor(_mentor_id)
      if Mentor.find(_mentor_id)
        date_querry = self.where(:mentor_id => _mentor_id).where("date <= LAST_DAY(CURDATE())").select("DISTINCT date").order("date ASC").reload
        return date_querry.collect(&:date).group_by {|check_in_date| check_in_date.year}
      end
      return []
    end
    
    def for_payment_period_between_dates(_payment_period_id, start_date, end_date)
      self.where(:payment_period_id => _payment_period_id, :date => start_date..end_date).reload
    end
    
    def with_payment_period(_payment_period_id)
      self.where(:payment_period_id => _payment_period_id).order('date ASC').reload
    end
    
    def for_mentor_on_date(_mentor_id, _date)
      lessons = self.with_mentor(_mentor_id).on_date(_date).reload
    end
  end
end
