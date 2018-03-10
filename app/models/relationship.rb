class Relationship < ApplicationRecord
  belongs_to :mentor, class_name: 'User'
  belongs_to :mentee, class_name: 'User'
  belongs_to :cohort, optional: true
end
