module PeopleHelper
  
  
  def contact_links(contacts)
    if not contacts.empty?
      return raw(contacts.each.map { |c| link_to c.full_name, [c.student, c] }.join(', '))
    end
  end
  
  def program_mentor(enrollments)
    unless enrollments.empty?
      return raw(enrollments.each.map { |e| "#{e.mentor.full_name}/#{e.instrument.title}" }.join(', '))
    end
  end
  
  def full_address(person)
    post_office = '' #string format: po_number city
    
    if !person.place.empty? and !person.post_office.nil?
      post_office = person.post_office.id.to_s + ' ' + person.place
    
    elsif !person.place.empty? and person.post_office.nil?
      p_o = PostOffice.find_by_name(person.place)
      if p_o
        post_office = p_o.id.to_s + ' ' + p_o.name
      else
        post_office = person.place
      end
    
    elsif !person.post_office.nil? and person.place.empty?
      post_office = person.post_office.id.to_s + ' ' + person.post_office.name
    
    else
      post_office = 'Naslov ni znan'
    end
    
    if !person.address.empty?
      return person.address + ', ' + post_office
    end
    
    return post_office
  end
end

