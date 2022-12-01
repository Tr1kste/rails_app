require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create :user }

  it '.full_name' do
    expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
  end

  describe 'relashionships' do
    it { should have_many(:posts).dependent(:destroy) }
  end

  describe 'validates' do
    it { should validate_uniqueness_of(:phone_number).ignoring_case_sensitivity }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { expect(user).to be_valid }
  end
end