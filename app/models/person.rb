class Person < ActiveRecord::Base
  has_many :relations, :class_name => "PersonalRelation"
  has_many :people, :through => :relations, :foreign_key => "related_person_id"
end
