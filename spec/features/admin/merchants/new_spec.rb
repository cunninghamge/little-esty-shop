require 'rails_helper'

describe "Admin Merchants Creation Page" do
  before(:each) do
    user = create(:user, role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end
  
  it "has a field for name that creates a disabled merchant when filled out" do
    visit new_admin_merchant_path
    added_text = "23urjwoajwfjmko"
    fill_in("merchant[name]", with: added_text)
    click_on "Submit"

    expect(current_path).to eq(admin_merchants_path)
    expect(page.find("#flash-messages")).to have_content("Successfully Added Merchant")
    within("#disabled-merchants") do
      expect(page).to have_content(added_text)
    end
  end

  it "properly handles an empty name" do
    visit new_admin_merchant_path
    added_text = ""
    fill_in("merchant[name]", with: added_text)
    click_on "Submit"

    expect(page.find("#flash-messages")).to have_content("Name can't be blank")
  end

end
