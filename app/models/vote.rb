class Vote < ApplicationRecord
  belongs_to :campaign
  validates :choice, :validity, presence: true
end
