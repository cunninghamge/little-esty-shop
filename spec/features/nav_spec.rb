require 'rails_helper'

RSpec.describe "navigation bar" do
  let(:merchant) {create(:merchant)}

  describe "options by user" do
    it "visitor" do
      visit root_path

      within(".main-nav") do
        expect(page).to have_link(href: root_path)
        expect(page).to have_link("Log In", href: login_path)
        expect(page).to have_link("Register", href: new_user_path)
        expect(page).to have_content("My Cart (0)")

        expect(page).not_to have_link(href: merchant_dashboard_path(merchant))
        expect(page).not_to have_link(href: admin_path)
        expect(page).not_to have_content("Logged in")
        expect(page).not_to have_link("Log Out")
      end
    end

    it "customer" do
      user = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit root_path

      within(".main-nav") do
        expect(page).to have_link(href: root_path)
        expect(page).to have_content("Logged in as #{user.username}")
        expect(page).to have_link("Log Out", href: logout_path)
        expect(page).to have_content("My Cart (0)")

        expect(page).not_to have_link(href: merchant_dashboard_path(merchant))
        expect(page).not_to have_link(href: admin_path)
        expect(page).not_to have_link("Log In")
        expect(page).not_to have_link("Register")
      end
    end

    it "merchant" do
      user = create(:user, role: 1, merchant: merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit merchant_dashboard_path(merchant)

      within(".main-nav") do
        expect(page).to have_link(href: merchant_dashboard_path(merchant))
        expect(page).to have_content("Logged in as #{user.username}")
        expect(page).to have_link("Log Out", href: logout_path)

        expect(page).not_to have_link(href: admin_path)
        expect(page).not_to have_content("My Cart (0)")
        expect(page).not_to have_link("Log In")
        expect(page).not_to have_link("Register")
      end
    end

    it "as an admin" do
      user = create(:user, role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit admin_path

      within(".main-nav") do
        expect(page).to have_link(href: admin_path)
        expect(page).to have_content("Logged in as #{user.username}")
        expect(page).to have_link("Log Out", href: logout_path)

        expect(page).not_to have_link(href: merchant_dashboard_path(merchant))
        expect(page).not_to have_link("Log In")
        expect(page).not_to have_link("Register")
        expect(page).not_to have_content("My Cart (0)")
      end
    end
  end

  describe "restrictions" do
    describe "does not allow a visitor to access merchant or admin pages" do
      it {visit admin_path}
      it {visit admin_invoices_path}
      it {visit admin_merchants_path}
      it {visit merchant_dashboard_path(merchant)}
      it {visit merchant_invoices_path(merchant)}
      it {visit merchant_items_path(merchant)}
      it {visit merchant_discounts_path(merchant)}

      after(:each) do
        expect(page.status_code).to eq(404)
      end
    end

    describe "does not allow a customer to access merchant or admin pages" do
      before(:each) do
        user = create(:user, role: 0)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it {visit merchant_dashboard_path(merchant)}
      it {visit merchant_invoices_path(merchant)}
      it {visit merchant_items_path(merchant)}
      it {visit merchant_discounts_path(merchant)}
      it {visit admin_path}
      it {visit admin_invoices_path}
      it {visit admin_merchants_path}

      after(:each) do
        expect(page.status_code).to eq(404)
      end
    end

    describe "does not allow a customer to access merchant or admin pages" do
      before(:each) do
        user = create(:user, role: 0)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it {visit merchant_dashboard_path(merchant)}
      it {visit merchant_invoices_path(merchant)}
      it {visit merchant_items_path(merchant)}
      it {visit merchant_discounts_path(merchant)}
      it {visit admin_path}
      it {visit admin_invoices_path}
      it {visit admin_merchants_path}

      after(:each) do
        expect(page.status_code).to eq(404)
      end
    end

    describe "does not allow a merchant to access admin pages" do
      before(:each) do
        user = create(:user, role: 1)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it {visit admin_path}
      it {visit admin_invoices_path}
      it {visit admin_merchants_path}

      after(:each) do
        expect(page.status_code).to eq(404)
      end
    end

    describe "allows a merchant to access merchant pages" do
      before(:each) do
        user = create(:user, role: 1, merchant: merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it {visit merchant_dashboard_path(merchant)}
      it {visit merchant_invoices_path(merchant)}
      it {visit merchant_items_path(merchant)}
      it {visit merchant_discounts_path(merchant)}

      after(:each) do
        expect(page.status_code).not_to eq(404)
      end
    end

    describe "allows an admin to access admin pages" do
      before(:each) do
        user = create(:user, role: 2)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it {visit admin_path}
      it {visit admin_invoices_path}
      it {visit admin_merchants_path}

      after(:each) do
        expect(page.status_code).to eq(200)
      end
    end
  end
end
