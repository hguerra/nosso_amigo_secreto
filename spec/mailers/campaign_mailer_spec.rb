require 'rails_helper'

RSpec.describe CampaignMailer, type: :mailer do
  describe 'raffle' do

    before do
      @campaign = create(:campaign)
      @member   = create(:member, campaign: @campaign)
      @friend = create(:member, campaign: @campaign)
      @mail = CampaignMailer.raffle(@campaign, @member, @friend)
    end

    it 'renders the headers' do
      expect(@mail.subject).to eq("Nosso Amigo Secreto: #{@campaign.title}")
      expect(@mail.to).to eq([@member.email])
    end

    it 'body have member name' do
      expect(@mail.body.encoded).to match(@member.name)
    end

    it 'body have campaign creator name' do
      expect(@mail.body.encoded).to match(@campaign.user.name)
    end

    it 'body have member link to set open' do
      expect(@mail.body.encoded).to match("/members/#{@member.token}/opened")
    end
  end

  describe 'invalid' do
    before do
      @campaign = create(:campaign)
      @mail = CampaignMailer.invalid(@campaign)
    end

    it 'renders the headers' do
      expect(@mail.subject).to eq("Falha ao criar campanha '#{@campaign.title}' no site Nosso Amigo Secreto")
      expect(@mail.to).to eq([@campaign.user.email])
    end

    it 'body have campaign creator name' do
      expect(@mail.body.encoded).to match(@campaign.user.name)
    end

    it 'body have campaign fails message' do
      expect(@mail.body.encoded).to match('n&#227;o foi finalizada com sucesso')
    end
  end
end
