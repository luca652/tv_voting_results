class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end

  def show
    @campaign = Campaign.find(params[:id])
    @results = @campaign.results
    @invalid_count = @campaign.invalid_votes.count
  end
end
