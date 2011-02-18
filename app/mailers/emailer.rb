class Emailer < ActionMailer::Base
  #default :from => "from@example.com"
  
  def contact(url='http://gvido.si/contacts')
    @subject = '[GVIDO] Novo sporočilo'
    @recipients = 'tomaz.pacnik@gvido.si'
    @from = 'GVIDO <info@gvido.si>'
    @sent_on = Time.now
    @url = url
    @headers = {}
  end
end
