require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:campaign) { Campaign.create!(name: "Test Campaign") }
  let(:vote) { Vote.new(campaign: campaign, validity: "during", choice: "Option A") }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(vote).to be_valid
    end

    it "is not valid without a campaign" do
      vote.campaign = nil
      expect(vote).not_to be_valid
      expect(vote.errors[:campaign]).to include("must exist")
    end

    it "is not valid without validity" do
      vote.validity = nil
      expect(vote).not_to be_valid
      expect(vote.errors[:validity]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "belongs to campaign" do
      assoc = described_class.reflect_on_association(:campaign)
      expect(assoc.macro).to eq :belongs_to
    end
  end

  describe '#valid_votes' do
    it 'returns valid votes during the campaign' do
      during_valid_vote = Vote.create!(campaign: campaign, validity: 'during', choice: 'Valid Choice')
      invalid_vote1 = Vote.create!(campaign: campaign, validity: 'pre', choice: 'Valid Choice')
      invalid_vote2 = Vote.create!(campaign: campaign, validity: 'during', choice: nil)

      valid_votes = campaign.valid_votes

      expect(valid_votes).to include(during_valid_vote)
      expect(valid_votes).not_to include(invalid_vote1, invalid_vote2)
    end
  end

  describe '#invalid_votes' do
    it 'returns invalid votes for the campaign' do
      during_valid_vote = Vote.create!(campaign: campaign, validity: 'during', choice: 'Valid Choice')
      invalid_vote1 = Vote.create!(campaign: campaign, validity: 'pre', choice: 'Valid Choice')
      invalid_vote2 = Vote.create!(campaign: campaign, validity: 'during', choice: nil)

      invalid_votes = campaign.invalid_votes

      expect(invalid_votes).to include(invalid_vote1, invalid_vote2)
      expect(invalid_votes).not_to include(during_valid_vote)
    end
  end

  describe '#results' do
    it 'returns results grouped by choice for valid votes during the campaign' do
      valid_vote1 = Vote.create!(campaign: campaign, validity: 'during', choice: 'Choice A')
      valid_vote2 = Vote.create!(campaign: campaign, validity: 'during', choice: 'Choice B')
      invalid_vote1 = Vote.create!(campaign: campaign, validity: 'pre', choice: 'Choice C')

      results = campaign.results

      expect(results).to eq({ 'Choice A' => 1, 'Choice B' => 1 })
      expect(results).not_to have_key('Choice C')
    end
  end
end
