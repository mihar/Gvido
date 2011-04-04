module GigsHelper
  def preforming_mentors(gig)
    unless gig.mentors.empty?
      return raw(gig.mentors.map { |m| m.full_name }.join(', '))
    end
    return 'Brez mentorjev'
  end
  
end
