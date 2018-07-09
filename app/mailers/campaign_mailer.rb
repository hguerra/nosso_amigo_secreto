class CampaignMailer < ApplicationMailer

  def raffle(campaign, member, friend)
    @campaign = campaign
    @member = member
    @friend = friend
    mail to: @member.email, subject: "Nosso Amigo Secreto: #{@campaign.title}"
  end

  def invalid(campaign)
    @campaign = campaign
    mail to: @campaign.user.email, subject: "Falha ao criar campanha '#{@campaign.title}' no site Nosso Amigo Secreto"
  end
end
