require 'spec_helper'

feature "See about page", %Q{
As a non logged in user
I want to see about page
Such that I learn how to use the system
} do
  scenario "visit page" do
    visit root_path
    click_on "about"
    expect_to_see "Author"
  end
end
