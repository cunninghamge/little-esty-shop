require 'rails_helper'

RSpec.describe "User authentication" do
  describe "user registration form" do
    it "creates a new user" do
      visit root_path
      click_link("Register")

      expect(current_path).to eq(new_user_path)

      fill_in("user[username]", with: "testuser")
      fill_in("user[password]", with: "testpassword")
      within("form") {click_on("Register")}

      expect(page).to have_content("Welcome, testuser!")
    end

    it "keeps a user logged in after registering" do
      visit root_path
      click_link("Register")

      expect(current_path).to eq(new_user_path)

      fill_in("user[username]", with: "testuser")
      fill_in("user[password]", with: "testpassword")
      within("form") {click_on("Register")}

      expect(page).to have_content("Welcome, testuser!")
      expect(page).to have_content("Logged in as testuser")
    end
  end

  describe "logging in/out" do
    it "can log in with valid credentials" do
      user = User.create(username: "testusername", password: "testpassword")

      visit root_path
      click_on "Log In"

      expect(current_path).to eq(login_path)

      fill_in :username, with: user.username
      fill_in :password, with: user.password
      within("form") {click_on "Log In"}

      expect(current_path).to eq(root_path)

      expect(page).to have_content("Welcome, #{user.username}")
      expect(page).to have_link("Log Out")
      expect(page).not_to have_link("Register")
      expect(page).not_to have_link("Log In")
    end

    it "cannot log in with bad credentials" do
      user = User.create(username: "testusername", password: "testpassword")

      visit root_path
      click_on "Log In"

      fill_in :username, with: user.username
      fill_in :password, with: "incorrect password"
      within('form') {click_on "Log In"}

      expect(current_path).to eq(login_path)

      expect(page).to have_content("Invalid username or password")
    end

    it "logging out" do
      user = User.create(username: "testusername", password: "testpassword")
      visit root_path
      click_on "Log In"
      expect(current_path).to eq('/login')
      fill_in :username, with: user.username
      fill_in :password, with: user.password
      within('form') {click_on "Log In"}

      click_on "Log Out"

      expect(current_path).to eq(root_path)
      expect(page).to have_content("Successfully logged out")
      expect(page).not_to have_link("Log Out")
      expect(page).to have_link("Register")
      expect(page).to have_link("Log In")
    end
  end

  describe "landing pages" do
    it "landing page for customer login is root path" do
      user = User.create(username: "testusername", password: "testpassword", role: 0)

      visit login_path
      fill_in :username, with: user.username
      fill_in :password, with: user.password
      within("form") {click_on "Log In"}

      expect(current_path).to eq(root_path)
    end

    it "landing page for merchant login is merchant dashboard" do
      merchant = create(:merchant)
      user = User.create(username: "testusername", password: "testpassword", role: 1, merchant: merchant)

      visit login_path
      fill_in :username, with: user.username
      fill_in :password, with: user.password
      within("form") {click_on "Log In"}

      expect(current_path).to eq(merchant_dashboard_path(merchant))
    end

    it "landing page for admin login is admin dashboard" do
      user = User.create(username: "testusername", password: "testpassword", role: 2)

      visit login_path
      fill_in :username, with: user.username
      fill_in :password, with: user.password
      within("form") {click_on "Log In"}

      expect(current_path).to eq(admin_path)
    end
  end
end
