require 'rails_helper'

RSpec.describe CampaignRaffleJob, type: :job do
  include ActiveJob::TestHelper

  before(:each) do
    @current_user = FactoryBot.create(:user)
  end

  describe 'Job definition' do
    it 'is in emails queue' do
      expect(CampaignRaffleJob.new.queue_name).to eq('emails')
    end
  end

  describe 'Executes perform' do
    before(:each) do
      @campaign = create(:campaign, user: @current_user)
    end

    it 'call raffle service with 4 members' do
      ActiveJob::Base.queue_adapter = :test

      create(:member, campaign: @campaign)
      create(:member, campaign: @campaign)
      create(:member, campaign: @campaign)
      create(:member, campaign: @campaign)
      CampaignRaffleJob.perform_later(@campaign)

      expect(CampaignRaffleJob).to have_been_enqueued.exactly(:once)
      expect(CampaignRaffleJob).to have_been_enqueued.with(@campaign)
    end

    it 'call raffle service with less than 3 members' do
      ActiveJob::Base.queue_adapter = :test

      create(:member, campaign: @campaign)
      CampaignRaffleJob.perform_later(@campaign)

      expect(CampaignRaffleJob).to have_been_enqueued.exactly(:once)
    end
  end
end
