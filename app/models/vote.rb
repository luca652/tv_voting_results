class Vote < ApplicationRecord
  belongs_to :campaign
  validates :validity, presence: true
end
