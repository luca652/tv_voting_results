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

    it "is not valid without choice" do
      vote.choice = nil
      expect(vote).not_to be_valid
      expect(vote.errors[:choice]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "belongs to campaign" do
      assoc = described_class.reflect_on_association(:campaign)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
