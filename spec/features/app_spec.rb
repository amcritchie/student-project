require "spec_helper"

def create_users
  visit "/registration"
  fill_in 'username', with: 'Phil'
  fill_in 'password', with: 'phil1'
  click_button "Register"
  visit "/registration"
  fill_in 'username', with: 'John'
  fill_in 'password', with: 'john1'
  click_button "Register"
  visit "/registration"
  fill_in 'username', with: 'Steve'
  fill_in 'password', with: 'steve1'
  click_button "Register"
  visit "/registration"
  fill_in 'username', with: 'Alex'
  fill_in 'password', with: 'pass123'
  click_button "Register"
end

def create_alex
  visit "/registration"
  fill_in 'username', with: 'alex'
  fill_in 'password', with: 'pass123'
  click_button "Register"
end

def alex_login
  visit "/"
  fill_in 'username', with: 'alex'
  fill_in 'password', with: 'pass123'
  expect(page).to have_button("Login")

  click_button "Login"
end

def alex_create_fish
  alex_login
  fill_in "fishname", with: 'Clownfish'
  fill_in "wikilink", with: 'http://en.wikipedia.org/wiki/Amphiprioninae'
  click_button "Create"
  fill_in "fishname", with: 'Pufferfish'
  fill_in "wikilink", with: 'http://en.wikipedia.org/wiki/Tetraodontidae'
  click_button "Create"
end

def phil_create_fish
  visit "/"
  fill_in 'Username', with: 'Phil'
  fill_in 'Password', with: 'phil1'
  click_button 'Login'
  fill_in "fishname", with: 'Salmon'
  fill_in "wikilink", with: 'http://en.wikipedia.org/wiki/Amphiprioninae'
  click_button "Create"
  fill_in "fishname", with: 'Tuna'
  fill_in "wikilink", with: 'http://en.wikipedia.org/wiki/Tetraodontidae'
  click_button "Create"
end

feature "Homepage and Registration" do
  scenario "check homepage" do
    visit "/"
    expect(page).to have_button("Register")
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
    expect(page).to have_button("Login")
  end
  scenario "check registration page" do
    visit "/"
    click_button "Register"
    expect(page).to have_content("Username")
    expect(page).to have_content("Password")
  end
end

feature "Register restrictions" do
  scenario "empty username" do
    visit "/registration"
    fill_in 'username', with: ''
    fill_in 'password', with: 'Ilovekittens'
    click_button "Register"
    expect(page).to have_content("Please fill in username")
  end
  scenario "empty password" do
    visit "/registration"
    fill_in 'username', with: 'Lindsay'
    fill_in 'password', with: ''
    click_button "Register"
    expect(page).to have_content("Please fill in password")
  end
  scenario "empty all" do
    visit "/registration"
    fill_in 'username', with: ''
    fill_in 'password', with: ''
    click_button "Register"
    expect(page).to have_content("Please fill in username and password")
  end
  scenario "duplicate usernames" do
    create_alex
    create_alex
    expect(page).to have_content("Username is already in use, please choose another.")
  end

end
feature "Fill in form and see greeting" do
  scenario "visit registration page" do
    create_alex
    expect(page).to have_content("Thank you for registering")
  end
end
feature "Login and out" do
  scenario "have logged out" do
    create_alex
    alex_login
    expect(page).to have_content("Welcome, Alex")
    expect(page).to have_button("Logout")
    expect(page).to have_no_button("Login")
    expect(page).to have_no_button("Register")

    click_button "Logout"
    expect(page).to have_no_button("Logout")
    expect(page).to have_button("Login")
    expect(page).to have_button("Register")
  end
end
feature "Display users" do
  scenario "on user page display other current users" do

    create_users
    alex_login
    expect(page).to have_content("John")
    expect(page).to have_content("Steve")
  end
  scenario "sort" do
    skip
    create_users
    alex_login
    expect(page).to have_content("Phil\nJohn\nSteve")
    choose('asc')
    click_button "Sort"
    expect(page).to have_content("John \n Phil \n Steve")
  end
  scenario "delete user" do
    create_users
    alex_login
    visit "/delete/phil"
    expect(page).to have_no_content("Phil")

  end
  scenario "create fish" do
    create_users
    alex_login
    fill_in "fishname", with: 'Clownfish'
    fill_in "wikilink", with: 'http://en.wikipedia.org/wiki/Amphiprioninae'
    click_button "Create"
    expect(page).to have_content("Clownfish")
  end
  scenario "check user fish" do
    create_users
    alex_create_fish
    visit "/"
    click_button "Logout"
    fill_in 'username', with: 'Phil'
    fill_in 'password', with: 'phil1'
    click_button "Login"
    expect(page).to have_no_content("Clownfish Pufferfish")
  end
  scenario "check other user's fish" do
    create_users
    alex_create_fish
    click_button "Logout"
    fill_in 'username', with: 'Phil'
    fill_in 'password', with: 'phil1'
    click_button "Login"
    select "Alex", from: "fish_list"
    click_button "Check Fish"
    expect(page).to have_content("Clownfish")
  end

end