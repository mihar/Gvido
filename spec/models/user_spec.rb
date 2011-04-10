require 'spec_helper'

describe User do
  subject do
    user = Factory.build :user
    user.email = Factory.next(:email)
    user.save
    user
  end
  
  it {
    unless subject.errors.empty?
      puts '-- Napake pri shranjevanju --'
      puts subject.errors.inspect
    end
    should be_valid   
  }
  
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
end
