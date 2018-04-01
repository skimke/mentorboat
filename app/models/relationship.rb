class Relationship < ApplicationRecord
  belongs_to :mentor, class_name: 'User'
  belongs_to :mentee, class_name: 'User'
  belongs_to :cohort, optional: true
  has_many :goals
  has_many :feedbacks
end
