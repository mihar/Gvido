module EnrollmentHelper
  class Programme
    attr_accessor :id
    attr_accessor :mentor_id
    attr_accessor :instrument_id
    attr_accessor :title
    attr_accessor :locations
    
    def initialize(_id, _mentor_id, _instrument_id, _title, _locations)
      id, mentor_id, instrument_id, title, locations = _id, _mentor_id, _instrument_id, _title, _locations
    end
  end
  
  class SelectBoxHelper
    attr_accessor :programmes
    attr_accessor :student
    
    def initialize(student = Student.new)
      get_programmes_ordered_by_mentor
      @student = student
    end
        
    def get_programmes_ordered_by_mentor
      index = 0
      Mentor.order('id ASC').each do |mentor|
        @programmes << mentor.instruments do |instrument| 
          Programme.new(
            index += 1, 
            mentor.id, 
            instrument.id, 
            "#{mentor.full_name}/#{instrument.title}",
            mentor.location_ids
            )
        end
      end
    end
    
    def select_box
      unless @student.contact.nil?
        return group_programmes_by_interest(student.contact)
      else
        return collection_select(:programme, :programme_id, @programmes, :id, :title)
      end
    end
    
    def group_programmes_by_interest(interest)
      ordered_programmes_list = []
      interest.locations.each do |location_of_interest|
        @programmes.each do |programme|
          if programme.locations.include?(location_of_interest.id)
            ordered_programmes_list << programme
          end
        end
      end
      
      @programmes = ordered_programmes_list + 
        @programmes.reject {|programme| ordered_programmes_list.include?(programme)}
        
      return collection_select(:programme, :programme_id, @programmes, :id, :title)
    end
    
  end
end
