class Question < ActiveRecord::Base
  default_scope order(:position)
end
