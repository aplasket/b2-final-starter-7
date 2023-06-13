require "rails_helper"

RSpec.describe "/merchants/:id/coupons, coupon index page", type: :feature do
  before(:each) do
    @hair = Merchant.create!(name: "Hair Care")
    @hair10 = Coupon.create!(name: "10% off", unique_code: "HAIR10OFF", amount_off: 10, discount_type: 0, merchant_id: @hair.id) #inactive
    @hair20 = Coupon.create!(name: "20% off", unique_code: "HAIR20OFF", amount_off: 20, discount_type: 0, merchant_id: @hair.id, status: 0) #active
    @hairships = Coupon.create!(name: "Free Shipping", unique_code: "HAIRFREESHIP", amount_off: 7, discount_type: 1, merchant_id: @hair.id) #inactive
    @love10 = Coupon.create!(name: "$10 off", unique_code: "LOVE10", amount_off: 10, discount_type: 1, merchant_id: @hair.id, status: 0) #active

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @hair.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @hair.id)

    @sallys = Merchant.create!(name: "Sally's Salon")
    @sallyships = Coupon.create!(name: "Free Shipping", unique_code: "SALLYFREESHIP", amount_off: 12, discount_type: 1, merchant_id: @sallys.id)
    @suziebest = Coupon.create!(name: "Suzie's Best Discount", unique_code: "OWNER50", amount_off: 50, discount_type: 0, merchant_id: @sallys.id)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @hair10.id) #coupon 2 uses - inactive
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @hair20.id) #coupon  2 uses - active
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @hairships.id) #coupon 1 use - inactive
    @invoice_4 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @hair20.id)
    @invoice_5 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @hair10.id)
    @invoice_6 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @love10.id) #coupon 1 use - active

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_2.id, quantity: 3, unit_price: 8, status: 2)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_1.id, quantity: 4, unit_price: 10, status: 2)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_2.id, quantity: 6, unit_price: 8, status: 2)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 203142, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 201042, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 208942, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 219402, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 248172, result: 1, invoice_id: @invoice_6.id)


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
      expect(page).to_not have_content(@suziebest.name)
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

      expect(page).to_not have_content(@sallys.name)
      expect(page).to_not have_content(@suziebest.name)
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

    #userstory 9
    it "displays a section for next 3 upcoming US holidays" do
      expect(page).to have_content("Upcoming Holidays")
      within "#upcoming-holidays" do
        expect(page).to have_content("Juneteenth - 2023-06-19")
        expect(page).to have_content("Independence Day - 2023-07-04")
        expect(page).to have_content("Labour Day - 2023-09-04")
        expect(page).to_not have_content("Columbus Day - 2023-10-09")
      end
    end

    #extension 1
    it "active/inactive coupons are sorted in order of popularity (count of use), most to least" do
      save_and_open_page
      within "#active-coupons" do
        expect(@hair20).to appear_before(@love10)
        expect(@hair20.count_used).to eq(2)
        expect(@love10.count_used).to eq(1)
      end

      within "#inactive-coupons" do
        expect(@hair10).to appear_before(@hairships)
        expect(@hair10.count_used).to eq(2)
        expect(@hairships.count_used).to eq(1)
      end
    end
  end
end