require 'rails_helper'

RSpec.describe 'Profile', type: :feature do
  before(:each) do
    @user = User.create(name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "test@turing.com",
                password: "123456",
                role: 0)
    @user2 = User.create(name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "a@a.com",
                password: "123456",
                role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit '/profile'
  end

  describe 'as a registered user when I visit my profile page' do
    it "I see my profile information except password" do

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.street_address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
      expect(page).to have_link("Edit My Profile Data")
    end

    it "and I click on edit, I can edit my profile information" do

      click_on("Edit My Profile Data")

      expect(current_path).to eq("/profile/#{@user.id}/edit")
      expect(find_field('Name').value).to eq "#{@user.name}"
      expect(find_field('street_address').value).to eq "#{@user.street_address}"
      expect(find_field('City').value).to eq "#{@user.city}"
      expect(find_field('State').value).to eq "#{@user.state}"
      expect(find_field('Zip').value).to eq "#{@user.zip}"
      expect(find_field('Email').value).to eq "#{@user.email}"

      fill_in 'Name', with: "Ana"
      fill_in 'street_address', with: "1234 New Bike Rd."
      fill_in 'City', with: "Denver"
      fill_in 'State', with: "CO"
      fill_in 'Zip', with: "80204"
      fill_in 'Email', with: "test@test.com"

      click_button("Submit Form")

      expect(current_path).to eq("/profile")

      expect(page).to have_content("Your profile is updated")
      expect(page).to have_content("Ana")
      expect(page).to have_content("1234 New Bike Rd.")
      expect(page).to have_content("Denver")
      expect(page).to have_content("CO")
      expect(page).to have_content("80204")
      expect(page).to have_content("test@test.com")
    end

    it "and I edit my information with an already existing email, I see an error message" do
      click_on("Edit My Profile Data")

      fill_in 'Email', with: "a@a.com"

      click_button("Submit Form")

      expect(current_path).to eq("/profile/#{@user.id}")
      expect(page).to have_content("Email has already been taken")
    end

    it "can update password" do
      click_on("Edit My Password")

      expect(current_path).to eq("/password/#{@user.id}/edit")

      fill_in :password, with: "NewPW1234!"
      fill_in :password_confirmation, with: "NewPW1234!"
      click_on("Submit")

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your password has been updated")
    end

    it "validates password presence and confirmation on update" do
      click_on("Edit My Password")

      expect(current_path).to eq("/password/#{@user.id}/edit")

      fill_in :password, with: ""
      fill_in :password_confirmation, with: ""
      click_on("Submit")

      expect(current_path).to eq("/password/#{@user.id}")
      expect(page).to have_content("You are missing required fields.")

      fill_in :password, with: "ABC"
      fill_in :password_confirmation, with: "123"
      click_on("Submit")

      expect(current_path).to eq("/password/#{@user.id}")
      expect(page).to have_content("Password and confirmation must match.")
    end
  end
end
