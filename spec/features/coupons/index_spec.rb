require "rails_helper"

RSpec.describe "/merchants/coupons, coupon index page", type: :feature do
  before(:each) do
    @hair = Merchant.create!(name: "Hair Care")
    @hair10 = Coupon.create!(name: "10% off", unique_code: "HAIR10OFF", amount_off: 10, discount_type: 0, merchant_id: @hair.id)
    @hair20 = Coupon.create!(name: "20% off", unique_code: "HAIR20OFF", amount_off: 20, discount_type: 0, merchant_id: @hair.id)
    @hairbogo50 = Coupon.create!(name: "Free Shipping", unique_code: "HAIRFREESHIP", amount_off: 7, discount_type: 1, merchant_id: @hair.id)

    @sallys = Merchant.create!(name: "Sally's Salon")
    @sallybogo50 = Coupon.create!(name: "Free Shipping", unique_code: "SALLYFREESHIP", amount_off: 12, discount_type: 1, merchant_id: @sallys.id)

    visit merchant_coupons_path(@hair)
  end

  describe "as a merchant on the coupon index page" do
    it "shows all of my coupons names" do
      expect(page).to have_content(@hair.name)
      expect(page).to have_content("Coupons:")
      expect(page).to have_content(@hair10.name)
      expect(page).to have_content(@hair20.name)

      expect(page).to_not have_content(@sallys.name)
      expect(page).to_not have_content(@sallybogo50.unique_code)

      save_and_open_page
    end

    xit "shows the coupon type and amount off" do

    end

    xit "all coupon names link to their show page" do

    end
  end
end