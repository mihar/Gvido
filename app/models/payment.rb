class Payment
  attr_accessor :price, :payment_date, :description, :period_discount, :payment_plan, :student_id, :enrollment_id
  
  DATE_SPACER = 19
  
  def initialize(_price, _description, _payment_date, _period_discount, _payment_plan, _student_id)
    self.price = _price
    self.description = _description
    self.payment_date = _payment_date
    self.period_discount = _period_discount
    self.payment_plan = _payment_plan
    self.student_id = _student_id
  end
  
  class << self
    # Logic for full or half prepayment deduction
    #
    def full_or_half_prepayment_deduction(_payment_plan_id, enrollment_date, cancel_date, _prepayment)
      if (_payment_plan_id == :singular) or (enrollment_date.month > 9 and cancel_date.month == 6) 
        return _prepayment
      else
        return _prepayment / 2
      end
    end

    # Creates new payments for a given payment period
    #
    def create(payment_period)
      enrollment = payment_period.enrollment(true)
      
      total_price         = enrollment.total_price
      enrollment_length   = enrollment.length
      enrollment_discount = enrollment.discount
      enrollment_date     = enrollment.enrollment_date
      prepayment          = self.full_or_half_prepayment_deduction(payment_period.payment_plan.id, enrollment.enrollment_date, enrollment.cancel_date, enrollment.prepayment)
      _period_discount    = payment_period.discount
      period_length       = payment_period.length
      period_start_date   = payment_period.start_date
      _payment_plan       = payment_period.payment_plan.title
      _student_id         = enrollment.student.id
      price_per_lesson    = enrollment.price_per_lesson
      enrollment_id       = enrollment.id
      
      return case payment_period.payment_plan.id
      when :monthly   then create_monthly_payments(
                              total_price, enrollment_length, enrollment_discount, enrollment_date, 
                              _period_discount, period_length, period_start_date, prepayment, _payment_plan, _student_id
                            )
      when :trimester then create_trimester_payments(
                              total_price, enrollment_length, enrollment_discount, enrollment_date, 
                              _period_discount, period_length, period_start_date, prepayment, _payment_plan, _student_id
                            )
      when :singular  then create_singular_payment(
                              total_price, enrollment_length, enrollment_discount, enrollment_date, 
                              _period_discount, period_length, period_start_date, prepayment, _payment_plan, _student_id
                            )
      when :per_hour  then create_payments_per_hour(price_per_lesson, payment_period.id, enrollment_date, prepayment, _student_id, _period_discount, _payment_plan)
      end
    end
    
    
    # Creates a payment for each month in payment period
    #
    def create_monthly_payments(
          total_price, enrollment_length, enrollment_discount, enrollment_date, 
          _period_discount, period_length, period_start_date, prepayment, _payment_plan, _student_id
        )
      payments = []
      period_length.times do |i|

        date_at_begining_of_month = period_start_date >> i
        _payment_date = date_at_begining_of_month + DATE_SPACER
        _price = (total_price - total_price * enrollment_discount) / enrollment_length
        _price -= _price * _period_discount
      
        if (date_at_begining_of_month == enrollment_date and enrollment_date.month == 9) or (_payment_date.month == 5)
          _price -= prepayment
        end
      
        _description = create_description(
                        total_price, enrollment_discount, enrollment_length, enrollment_date, 
                        _period_discount, period_start_date, _payment_date, prepayment, _price)
                        
        payments << self.new(_price.truncate(2), _description, _payment_date, _period_discount, _payment_plan, _student_id)
      end
      payments
    end
    
    # Creates a payment for month in a payment period. Calculations are done through number of monthly lessons
    #
    def create_payments_per_hour(price_per_lesson, _payment_period_id, enrollment_date, prepayment, _student_id, _period_discount, _payment_plan)
      payments = []
      monthly_lessons = MonthlyLesson.with_payment_period(_payment_period_id)
      _price = BigDecimal('0')
      monthly_lessons.each do |ml|
        _price = ml.hours * price_per_lesson
        _price -= _price * _period_discount
        
        if (ml.date == enrollment_date and enrollment_date.month == 9) or (ml.date.month == 5)
          _price -= prepayment
        end
        
        _payment_date = ml.date + DATE_SPACER
        _description = "TODO"
        
        payments << self.new(_price.truncate(2), _description, _payment_date, _period_discount, _payment_plan, _student_id)
      end      
      payments
    end
    
    # Creates a payment for each trimester
    #
    def create_trimester_payments(
          total_price, enrollment_length, enrollment_discount, enrollment_date, 
          _period_discount, period_length, period_start_date, prepayment, _payment_plan, _student_id
        )
      payments = []
      (period_length/3).times do |i|

        date_at_begining_of_month = period_start_date >> (i * 3)
        _payment_date = date_at_begining_of_month + DATE_SPACER
        _price = (total_price - total_price * enrollment_discount) / enrollment_length
        _price -= _price * _period_discount
        _price *= 3
      
        if (date_at_begining_of_month == enrollment_date and enrollment_date.month == 9) or _payment_date.month == 3
          _price -= prepayment
        end
      
        _description = 'TODO'
        # _description = create_description(
        #                 total_price, enrollment_discount, enrollment_length, enrollment_date, 
        #                 _period_discount, period_start_date, _payment_date, prepayment, _price)
                        
        payments << self.new(_price.truncate(2), _description, _payment_date, _period_discount, _payment_plan, _student_id)
      end
      payments
    end
    
    # Creates one payment for the whole enrollment
    #
    def create_singular_payment(
          total_price, enrollment_length, enrollment_discount, enrollment_date, 
          _period_discount, period_length, period_start_date, prepayment, _payment_plan, _student_id
        )
      payments = []

      date_at_begining_of_month = period_start_date
      _payment_date = date_at_begining_of_month + DATE_SPACER
      _price = total_price - total_price * enrollment_discount
      _price -= _price * _period_discount
    
      if _payment_date.month == 9
        _price -= prepayment
      end
    
      _description = 'TODO'
      # _description = create_description(
      #                 total_price, enrollment_discount, enrollment_length, enrollment_date, 
      #                 _period_discount, period_start_date, _payment_date, prepayment, _price)
                      
      payments << self.new(_price.truncate(2), _description, _payment_date, _period_discount, _payment_plan, _student_id)

      payments
    end
    
    # And this is bogus
    #
    def create_description(
          total_price, enrollment_discount, enrollment_length, enrollment_date, 
          _period_discount, period_start_date, _payment_date, prepayment, _price
        )
      _description = ""
    
      if (enrollment_discount == 0.0 and _period_discount == 0.0 and prepayment == 0.0) or
        (enrollment_discount == 0.0 and _period_discount == 0.0 and prepayment > 0.0 and 
          enrollment_date != _payment_date.at_beginning_of_month and
          _payment_date.month  != 5)
        _description += "<p><strong>Kratek opis</strong>: Navaden obrok </p>"
        _description += "<p><strong>Izračun</strong>: obrok = šolnina/število mesecev </p>"
        _description += "<p><strong>Dejanski izračun</strong>: #{_price} = #{total_price} / #{enrollment_length} </p>"
      
      elsif enrollment_discount == 0.0 and _period_discount == 0.0 and prepayment > 0.0 
        _description += "<p><strong>Kratek opis</strong>: Obrok z odšteto kavcijo </p>"
        _description += "<p><strong>Izračun</strong>: obrok = šolnina/število mesecev - kavcija/2 </p>"
        _description += "<p><strong>Dejanski izračun</strong>: #{_price} = #{total_price} / #{enrollment_length} - #{prepayment}</p>"
      
      elsif (enrollment_discount > 0 and _period_discount == 0 and prepayment == 0) or
            (enrollment_discount > 0 and _period_discount == 0.0 and prepayment > 0.0 and 
              enrollment_date != _payment_date.at_beginning_of_month and _payment_date.month != 5)
        _description += "<p><strong>Kratek opis</strong>: Obrok s popustom na šolnino </p>"
        _description += "<p><strong>Izračun</strong>:  obrok = (šolnina - šolnina * popust)/število mesecev </p>"
        _description += "<p><strong>Dejanski izračun</strong>: #{_price} = (#{total_price} - #{total_price * enrollment_discount})/ #{enrollment_length} </p>"
      
      elsif enrollment_discount > 0 and _period_discount == 0.0 and prepayment > 0.0
        _description += "<p><strong>Kratek opis</strong>: Obrok s popustom na šolnino in odšteto kavcijo</p>"
        _description += "<p><strong>Izračun</strong>:  obrok = (šolnina - šolnina * popust)/število mesecev - kavcija/2 </p>"
        _description += "<p><strong>Dejanski izračun</strong>: #{_price} = (#{total_price} - #{total_price * enrollment_discount})/ #{enrollment_length} - #{prepayment}</p>"
        
      elsif (enrollment_discount > 0 and _period_discount > 0 and prepayment == 0) or
            (enrollment_discount > 0 and _period_discount > 0 and prepayment > 0.0 and 
              enrollment_date != _payment_date.at_beginning_of_month and _payment_date.month != 5)
        _description += "<p><strong>Kratek opis</strong>: Obrok s popustom na šolnino in popustom na obrok</p>"
        _description += "<p><strong>Izračun</strong>: obrok = ((šolnina - šolnina * popust)/število mesecev - (šolnina - šolnina * popust)/število mesecev * popust na obrok) </p>"
        _description += "<p><strong>Dejanski izračun</strong>: #{_price} = (#{total_price} - #{total_price * enrollment_discount})/ #{enrollment_length} - #{(total_price - total_price * enrollment_discount)/enrollment_length} * #{_period_discount} </p>"
      else
        _description += "<p><strong>Kratek opis</strong>: Obrok s popustom na šolnino in popustom na obrok in odšteto kavcijo</p>"
        _description += "<p><strong>Izračun</strong>: obrok = ((šolnina - šolnina * popust)/število mesecev - (šolnina - šolnina * popust)/število mesecev * popust na obrok) - kavcija/2</p>"
        _description += "<p><strong>Dejanski izračun</strong>: #{_price} = (#{total_price} - #{total_price * enrollment_discount})/ #{enrollment_length} - #{(total_price - total_price * enrollment_discount)/enrollment_length} * #{_period_discount} - #{prepayment}</p>"
      end
      _description
    end
  
  end
  
end