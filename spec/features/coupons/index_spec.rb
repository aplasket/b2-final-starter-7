require "rails_helper"

RSpec.describe "/merchants/:id/coupons, coupon index page", type: :feature do
  before(:each) do
    @hair = Merchant.create!(name: "Hair Care")
    @hair10 = Coupon.create!(name: "10% off", unique_code: "HAIR10OFF", amount_off: 10, discount_type: 0, merchant_id: @hair.id)
    @hair20 = Coupon.create!(name: "20% off", unique_code: "HAIR20OFF", amount_off: 20, discount_type: 0, merchant_id: @hair.id, status: 0)
    @hairships = Coupon.create!(name: "Free Shipping", unique_code: "HAIRFREESHIP", amount_off: 7, discount_type: 1, merchant_id: @hair.id)

    @sallys = Merchant.create!(name: "Sally's Salon")
    @sallyships = Coupon.create!(name: "Free Shipping", unique_code: "SALLYFREESHIP", amount_off: 12, discount_type: 1, merchant_id: @sallys.id)

    visit merchant_coupons_path(@hair)
  end

  describe "as a merchant on the coupon index page" do
    #userstory 1
    it "shows all of my coupons names, coupon type & amount off" do
      expect(page).to have_content(@hair.name)
      expect(page).to have_content("Coupons:")

      within ".coupon-#{@hair10.id}" do
        expect(page).to have_link("#{@hair10.name}")
        expect(page).to have_content("Amount off: #{@hair10.amount_off} #{@hair10.discount_type}")
      end

      within ".coupon-#{@hair20.id}" do
        expect(page).to have_link("#{@hair20.name}")
        expect(page).to have_content("Amount off: #{@hair20.amount_off} #{@hair20.discount_type}")
      end

      expect(page).to_not have_content(@sallys.name)
      expect(page).to_not have_content(@sallyships.unique_code)
    end

    it "all coupon names link to their show page" do
      within ".coupon-#{@hair20.id}" do
        click_link @hair20.name
        expect(current_path).to eq(merchant_coupon_path(@hair, @hair20))
      end
    end

    #userstory 2
    it "has a link to make a new coupon" do
      expect(page).to have_link("Create New Coupon")
      click_link "Create New Coupon"
      expect(current_path).to eq(new_merchant_coupon_path(@hair))
    end

    #userstory 6
    it "displays all coupons in active/inactive sections" do
      expect(page).to have_content("Active Coupons:")
      expect(page).to have_content("Inactive Coupons:")

      within "#active-coupons" do
        within ".coupon-#{@hair20.id}" do
          expect(page).to have_link("#{@hair20.name}")
        end
      end

      within "#inactive-coupons" do
        within ".coupon-#{@hair10.id}" do
          expect(page).to have_link("#{@hair10.name}")
        end
        within ".coupon-#{@hairships.id}" do
          expect(page).to have_link("#{@hairships.name}")
        end
      end

      expect(page).to_not have_content(@sallyships.unique_code)
      expect(page).to_not have_content(@sallys.name)
    end

    it "updates the section a coupon is when it is activated/deactivated on its show page" do
      expect(@hair10.status).to eq("inactive")

      within "#inactive-coupons" do
        within ".coupon-#{@hair10.id}" do
          expect(page).to have_link("#{@hair10.name}")
          click_link "#{@hair10.name}"
        end
      end

      expect(current_path).to eq(merchant_coupon_path(@hair, @hair10))

      within "#status-#{@hair10.id}" do
        expect(@hair10.status).to eq("inactive")
        expect(page).to have_button("Activate Coupon")
        click_button "Activate Coupon"
      end

      expect(current_path).to eq(merchant_coupon_path(@hair, @hair10))
      expect(page).to have_content("Status: active")


      visit merchant_coupons_path(@hair)

      within "#active-coupons" do
        within ".coupon-#{@hair10.id}" do
          expect(page).to have_link(@hair10.name)
        end
      end
    end
  end
end