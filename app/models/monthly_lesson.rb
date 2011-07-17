class MonthlyLesson < ActiveRecord::Base
  belongs_to :student
  belongs_to :enrollment
  belongs_to :mentor
  belongs_to :payment_period
  #belongs_to :invoice
  
  scope :public_lessons, where(:public_lesson => true)
  scope :on_date, lambda { |_date| where("YEAR(date) = ?", _date.year).where("MONTH(date) = ?", _date.month) } # Ful premal uporabljas scope. Pol teh metod bi moral prepisat v scope, ker je potem vse skupaj bolj resuable code!
  
  validates_numericality_of :hours, :greater_than_or_equal_to => 0

  CHECK_IN_DATE_SPACER = 4

  class << self
    def with_mentor(_mentor_id)
      where(:mentor_id => _mentor_id)
    end
    
    def on_date_with_mentor(_date, _mentor_id)
      lessons_on_date = MonthlyLesson.on_date(_date).with_mentor(_mentor_id).reload
    end
    
    def lessons_done_for_student_with_enrollment(_student_id, _enrollment_id)
      self.where(:student_id => _student_id).where(:enrollment_id => _enrollment_id).reload.sum(:hours)
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
    
    def update_public lesson, mentor
      if lesson and lesson["hours"] and lesson["instrument"] and lesson["students"] and lesson["students"].any?
        lesson["students"].each do |student_id|
          current_enrollment = Enrollment.find_by_student_id_and_mentor_id_and_instrument_id student_id, mentor.id, lesson["instrument"]
          return unless current_enrollment
          date = Date.civil(lesson["date(1i)"].to_i, lesson["date(2i)"].to_i, lesson["date(3i)"].to_i)
          new_lesson = self.new
          new_lesson.date = date
          new_lesson.hours = lesson["hours"]
          new_lesson.enrollment = current_enrollment
          new_lesson.student_id = student_id
          new_lesson.mentor = mentor
          new_lesson.public_lesson = true
          new_lesson.save
        end
      end
    end
  end
end
