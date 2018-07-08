require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe 'POST #create' do
    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'

      @campaign = create(:campaign, user: @current_user)
      @member_attributos = attributes_for(:member, campaign_id: @campaign.id)
    end

    it 'Create new member' do
      post :create, params: { member: @member_attributos }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id'].is_a?(Numeric)).to eq(true)
    end

    it 'Raise an error when creating a new member' do
      @member_attributos[:campaign_id] = nil
      post :create, params: { member: @member_attributos }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['campaign'][0]).to eq('must exist')
    end
  end

  describe 'PUT #update' do
    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'

      @campaign = create(:campaign, user: @current_user)
      @member = create(:member, campaign: @campaign)
    end

    it 'Update member' do
      new_name = 'MyNewName'

      put :update, params: { id: @member.id, member: { name: new_name } }

      expect(response).to have_http_status(:success)
      expect(Member.last.name).to eq(new_name)
    end

    it 'Raise an error when updating a member' do
      put :update, params: { id: @member.id, member: { campaign_id: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['campaign'][0]).to eq('must exist')
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'

      @campaign = create(:campaign, user: @current_user)
      @member = create(:member, campaign: @campaign)
    end

    it 'Delete member' do
      delete :destroy, params: { id: @member.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #opened' do
    before(:each) do
      request.env['HTTP_ACCEPT'] = 'image/gif'

      @campaign = create(:campaign, user: @current_user)
      @member = create(:member, campaign: @campaign)
      @member.set_pixel
    end

    it 'Invite Opened' do
      get :opened, params: { token: @member.token }

      expect(response).to have_http_status(:success)
    end
  end
end
