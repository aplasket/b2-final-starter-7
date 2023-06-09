require "rails_helper"

RSpec.describe "/merchants/coupons, coupon index page", type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @hair10 = coupon1 = Coupon.create!(name: "10% off", code: "HAIR10OFF", type: "percent-off", merchant_id: @merchant1.id)
    @hair20 = Coupon.create!(name: "20% off", code: "HAIR20OFF", type: "percent-off", merchant_id: @merchant1.id)
    @hairbogo50 = Coupon.create!(name: "BOGO 50", code: "HAIRBOGO50", type: "dollar-off", merchant_id: @merchant1.id)

    @merchant2 = Merchant.create!(name: "Sally's Salon")
    @sallybogo50 = Coupon.create!(name: "BOGO 50", code: "SALLYBOGO50", type: "dollar-off", merchant_id: @merchant2.id)

    visit merchant_coupons_path(@merchant1)
  end

  describe "as a merchant on the coupon index page" do
    it "shows all of my coupons names" do
      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@hair10.name)
      expect(page).to have_content(@hair20.name)

      expect(page).to_not have_content(@merchant2.name)
      expect(page).to_not have_content(@sallybogo50.name)
    end

    xit "shows the coupon type and amount off" do
      expect(page).
    end

    xit "all coupon names link to their show page" do

    end
  end
end