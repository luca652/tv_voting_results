class Campaign < ApplicationRecord
  has_many :votes
  validates :name, presence: true, uniqueness: true

  def valid_votes
    votes.where(validity: 'during').where.not(choice: [nil, ''])
  end

  def invalid_votes
    votes.where(validity: ['pre', 'post']).or(votes.where(choice: [nil, '']))
  end

  def results
    valid_votes.group(:choice).count
  end
end
