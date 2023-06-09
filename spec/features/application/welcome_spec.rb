require "rails_helper"

RSpec.describe "welcome page" do
  it "shows a welcome message" do
    visit root_path

    expect(page).to have_content("Click here to access the Admin Dashboard")
    expect(page).to have_link("Admin Dashboard")
    click_link("Admin Dashboard")
    expect(current_path).to eq(admin_dashboard_index_path)

    expect(page).to have_content("Merchant's Dashboard:")
    expect(page).to have_content("To navigate to merchant shop, input the url for the merchant using this format: /merchants/merchant_id/dashboard")
  end
end