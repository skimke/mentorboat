class Goal < ApplicationRecord
  belongs_to :relationship

  validates :title, presence: true
end
