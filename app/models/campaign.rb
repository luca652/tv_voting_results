class Campaign < ApplicationRecord
  has_many :votes
  validates :name, presence: true, uniqueness: true
end
