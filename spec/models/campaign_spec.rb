require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let(:campaign) { Campaign.new(name: "Test Campaign") }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(campaign).to be_valid
    end

    it "is not valid without a name" do
      campaign.name = nil
      expect(campaign).not_to be_valid
      expect(campaign.errors[:name]).to include("can't be blank")
    end

    it "is not valid with a duplicate name" do
      Campaign.create!(name: "Test Campaign")
      duplicate_campaign = Campaign.new(name: "Test Campaign")
      expect(duplicate_campaign).not_to be_valid
      expect(duplicate_campaign.errors[:name]).to include("has already been taken")
    end
  end

  describe "associations" do
    it "has many votes" do
      assoc = described_class.reflect_on_association(:votes)
      expect(assoc.macro).to eq :has_many
    end
  end
end
