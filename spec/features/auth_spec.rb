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

      visit '/items'

      expect(page).to have_content("Logged in as testuser")
    end
  end

  describe "logging in/out" do
    it "can log in with valid credentials" do
      user = User.create(username: "testusername", password: "testpassword")

      visit root_path

      click_on "Log In"

      expect(current_path).to eq('/login')

      fill_in :username, with: user.username
      fill_in :password, with: user.password

      click_on "Log In"

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

      expect(current_path).to eq('/login')

      fill_in :username, with: user.username
      fill_in :password, with: "incorrect password"

      click_on "Log In"

      expect(current_path).to eq('/login')

      expect(page).to have_content("Sorry, your credentials are bad.")
    end

    it "logging out" do
      user = User.create(username: "testusername", password: "testpassword")
      visit root_path
      click_on "Log In"
      expect(current_path).to eq('/login')
      fill_in :username, with: user.username
      fill_in :password, with: user.password
      click_on "Log In"

      click_on "Log Out"

      expect(current_path).to eq(root_path)
      expect(page).to have_content("Successfully Logged Out")
      expect(page).not_to have_link("Log Out")
      expect(page).to have_link("Register")
      expect(page).to have_link("Log In")
    end
  end
end
