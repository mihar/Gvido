class PaymentPlan
  attr_accessor :id, :title

  PAYMENT_PLANS = {
    :monthly => "Vsak mesec", 
    :trimester => "Vsak trimester", 
    :singular => "Enkratni znesek",
    :per_hour => "Na uro"
  }
  
  def initialize(options = {})
    self.id = options[:id] if options[:id]
    self.title = options[:title] if options[:title]
  end
  
  def self.find(id)
    return unless id
    id = id.to_sym
    self.new :id => id, :title => PAYMENT_PLANS[id]
  end
  
  def self.all
    PAYMENT_PLANS.map { |array| self.new :id => array[0], :title => array[1] }
  end
  
  def self.to_hash
    PAYMENT_PLANS
  end
  
  def monthly?
    id == :monthly
  end
  
  def trimester?
    id == :trimester
  end
  
  def singular?
    id == :singular
  end
  
  def to_s
    title
  end
end


