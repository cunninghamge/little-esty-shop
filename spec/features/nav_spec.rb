require 'rails_helper'

RSpec.describe "navigation bar" do
  describe "options by user" do
    it "visitor" do
      visit root_path

      within("#nav") do
        expect(page).to have_link("Home", href: root_path)
        expect(page).to have_link("Items", href: items_path)
        expect(page).to have_link("Log In", href: login_path)
        expect(page).to have_link("Register", href: new_user_path)
        expect(page).to have_content("My Cart (0)")
      end
    end

    it "default user" do
      user = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit root_path

      within("#nav") do
        expect(page).to have_link("Home", href: root_path)
        expect(page).to have_link("Items", href: items_path)
        expect(page).to have_content("Logged in as #{user.username}")
        expect(page).to have_link("Log Out", href: login_path)
        expect(page).to have_content("My Cart (0)")
        expect(page).not_to have_link("Log In")
        expect(page).not_to have_link("Register")
      end
    end

    it "merchant" do
      user = create(:user, role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit dashboard_merchant_path

      within("#nav") do
        expect(page).to have_link("Home", href: root_path)
        expect(page).to have_content("Logged in as #{user.username}")
        expect(page).to have_link("Log Out", href: login_path)
        expect(page).to have_link("Dashboard", href: dashboard_merchant_path)
        expect(page).not_to have_link("Items")
        expect(page).to have_content("My Cart (0)")
        expect(page).not_to have_link("Log In")
        expect(page).not_to have_link("Register")
      end
    end

    it "as an admin" do
      user = create(:user, role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit admin_path

      within("#nav") do
        expect(page).to have_link("Home", href: root_path)
        expect(page).to have_content("Logged in as #{user.username}")
        expect(page).to have_link("Log Out", href: login_path)
        expect(page).to have_link("Dashboard", href: admin_path)
        expect(page).not_to have_link("Items")
        expect(page).to have_content("My Cart (0)")
        expect(page).not_to have_link("Log In")
        expect(page).not_to have_link("Register")
      end
    end
  end

  describe "restrictions" do
    describe "does not allow a visitor to access merchant or admin pages" do
      it {visit dashboard_merchant_path}
      it {visit merchant_invoices_path}
      it {visit merchant_items_path}
      it {visit merchant_discounts_path}
      it {visit admin_path}
      it {visit admin_invoices_path}
      it {visit admin_merchants_path}

      after(:each) do
        expect(page.status_code).to eq(404)
      end
    end

    describe "does not allow a default user to access merchant or admin pages" do
      before(:each) do
        user = create(:user, role: 0)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it {visit dashboard_merchant_path}
      it {visit merchant_invoices_path}
      it {visit merchant_items_path}
      it {visit merchant_discounts_path}
      it {visit admin_path}
      it {visit admin_invoices_path}
      it {visit admin_merchants_path}

      after(:each) do
        expect(page.status_code).to eq(404)
      end
    end

    describe "does not allow a default user to access merchant or admin pages" do
      before(:each) do
        user = create(:user, role: 0)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end
      it {visit dashboard_merchant_path}
      it {visit merchant_invoices_path}
      it {visit merchant_items_path}
      it {visit merchant_discounts_path}
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
        user = create(:user, role: 1)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it {visit dashboard_merchant_path}
      it {visit merchant_invoices_path}
      it {visit merchant_items_path}
      it {visit merchant_discounts_path}

      after(:each) do
        expect(page.status_code).to eq(200)
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
