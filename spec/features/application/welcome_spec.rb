require "rails_helper"

RSpec.describe "welcome page" do
  it "shows a welcome message" do
    visit root_path
    expect(page).to have_content("Welcome to La Coupon Shoppe")
  end
end