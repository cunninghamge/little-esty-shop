require 'rails_helper'

RSpec.describe User do
  describe 'relationships' do
    it {should belong_to(:merchant).optional}
  end

  describe 'validations' do
    it {should validate_presence_of(:username)}
    it {should validate_uniqueness_of(:username)}
    it {should validate_presence_of(:password)}
  end

  describe 'roles' do
    it "can be a default user" do
      user = create(:user)

      expect(user.role).to eq("default")
    end

    it "can be a merchant" do
      user = create(:user, role: 1)

      expect(user.role).to eq("merchant")
    end

    it "can be an admin" do
      user = create(:user, role: 2)

      expect(user.role).to eq("admin")
    end
  end
end
