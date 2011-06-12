module StudentsHelper
  def location_details_links(active_enrollments)
    active_enrollments.collect(&:mentor).collect(&:locations).flatten.uniq.collect { |location| link_to location, details_location_path(location) }.to_sentence.html_safe
  end
  
  def location_section_links(active_enrollments)
    active_enrollments.collect(&:mentor).collect(&:locations).flatten.uniq.collect(&:location_section).flatten.uniq.collect { |location_section| link_to location_section, location_section }.to_sentence.html_safe
  end
  
  def net_ammount(total_price, discount)
    discount > 0 ? total_price - total_price * discount : total_price
  end
  
  def payment_type(value)
    case value
      when 1 then return "Navadno plačilo"
      when 2 then return "Odšteta polovica kavcije"
      when 3 then return "Odšteta celotna kavcija"
      when 4 then return "Kavcija"
      when 5 then return "Vpisnina"
    end
  end
  
  def program_mentor(enrollments)
    unless enrollments.empty?
      return raw(enrollments.each.map { |e| "#{e.mentor.to_s}/#{e.instrument.to_s}" }.join(', '))
    end
  end
end

