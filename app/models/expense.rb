class Expense < ActiveRecord::Base
  belongs_to :mentor
  
  scope :on_date, lambda { |_date| where("incurred_at >= ?", _date.beginning_of_month).where("incurred_at <= ?", _date.end_of_month) }
  scope :with_name, lambda { |_name| where(:name => name) }
  
  def self.update_bulk expenses, mentor
    if expenses and expenses.any?
      expenses.each do |date, e|
        date = Date.civil(Date.today.year, 6, e["day"].to_i)
        
        # If we find an expense on the same date with the same date, we use this one and update it.
        if expense = on_date(date).with_name(e["name"]).first
          expense.update_attributes :amount => e["amount"]
        else
          expense = self.create :name => e["name"], :amount => e["amount"], :incurred_at => date, :mentor => mentor
        end
      end
    end
  end
end
