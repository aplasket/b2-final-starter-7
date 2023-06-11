require "rails_helper"

RSpec.describe "/merchants/id/coupons/new, coupon new page", type: :feature do
  before(:each) do
    @hair = Merchant.create!(name: "Hair Care")
    @hair10 = Coupon.create!(name: "10% off", unique_code: "HAIR10OFF", amount_off: 10, discount_type: 0, merchant_id: @hair.id)
    @hair20 = Coupon.create!(name: "20% off", unique_code: "HAIR20OFF", amount_off: 20, discount_type: 0, merchant_id: @hair.id, status: 0)
    @hairships = Coupon.create!(name: "Free Shipping", unique_code: "HAIRFREESHIP", amount_off: 7, discount_type: 1, merchant_id: @hair.id)

    @sallys = Merchant.create!(name: "Sally's Salon")
    @sallyships = Coupon.create!(name: "Free Shipping", unique_code: "SALLYFREESHIP", amount_off: 12, discount_type: 1, merchant_id: @sallys.id)

    visit new_merchant_coupon_path(@hair)
  end

  describe "as a merchant on the coupon new page" do
    #user story 2
    it "can create a new coupon" do
      expect(page).to have_content("New Coupon")

      fill_in "Name", with: "50% off"
      fill_in "Unique code", with: "HAIR50OFF"
      fill_in "Amount off", with: 50
      select "percent", from: "Discount type"
      click_button "Create Coupon"

      expect(current_path).to eq(merchant_coupons_path(@hair))
      expect(page).to have_content("50% off")
      expect(page).to have_content("New Coupon has been created!")
    end

    #sad path for user story 2
    it "can't create a new coupon if the unique_code already exists in database" do
      expect(page).to have_content("New Coupon")

      fill_in "Name", with: "All shampoo products 10% off"
      fill_in "Unique code", with: "HAIR10OFF"
      fill_in "Amount off", with: 10
      select "percent", from: "Discount type"

      click_button "Create Coupon"

      expect(current_path).to eq(new_merchant_coupon_path(@hair))
      expect(page).to have_content("Unique code has already been taken")
    end
  end
end