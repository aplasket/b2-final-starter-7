require "rails_helper"

RSpec.describe "/merchants/:id/coupons/id, coupon show page" do
  before(:each) do
    @hair = Merchant.create!(name: "Hair Care")
    @hair10 = Coupon.create!(name: "10% off", unique_code: "HAIR10OFF", amount_off: 10, discount_type: 0, merchant_id: @hair.id)
    @hair20 = Coupon.create!(name: "20% off", unique_code: "HAIR20OFF", amount_off: 20, discount_type: 0, merchant_id: @hair.id, status: 0)
    @hairbogo50 = Coupon.create!(name: "Free Shipping", unique_code: "HAIRFREESHIP", amount_off: 7, discount_type: 1, merchant_id: @hair.id)

    @sallys = Merchant.create!(name: "Sally's Salon")
    @sallyships = Coupon.create!(name: "Free Shipping", unique_code: "SALLYFREESHIP", amount_off: 12, discount_type: 1, merchant_id: @sallys.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @hair.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @hair.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @sallys.id)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @hair10.id) # c1 has 2 successful transactions
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @hair10.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @hair10.id) #c2 has 1 successful transaction
    @invoice_4 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @hair10.id) # this one is a failed transaction
    @invoice_5 = Invoice.create!(customer_id: @customer_3.id, status: 2, coupon_id: @hair10.id) #c3 has 0 successful transactions

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_1.id, quantity: 3, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_1.id, quantity: 3, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id) #c1.1 success
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id) #c1.2 success
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id) #c2.1 success
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 0, invoice_id: @invoice_4.id) #c2.2 fail
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 0, invoice_id: @invoice_5.id) #c3.1 fail
  end

  describe "as a merchant, on the coupon show page" do
    it "displays the coupons name, code, amount, discount type, and status" do
      visit merchant_coupon_path(@hair, @hair10)

      expect(page).to have_content("Coupon Name: #{@hair10.name}")
      expect(page).to have_content("Code: #{@hair10.unique_code}")
      expect(page).to have_content("Amount off: $#{@hair10.amount_off} #{@hair10.discount_type}")
      expect(page).to have_content("Status: #{@hair10.status}")
      expect(page).to_not have_content(@hair20.name)
    end

    it "displays the count of how many times the coupon has been used" do
      visit merchant_coupon_path(@hair, @hair10)

      expect(page).to have_content("Times Used: #{@hair10.count_used}") #should equal 3
    end

    it "displays a button to deactivate the coupon" do
      visit merchant_coupon_path(@hair, @hair20)

      expect(@hair20.status).to eq("active")
      expect(page).to have_content("Status: active")

      within "#status-#{@hair20.id}" do
        expect(page).to have_button("Deactivate Coupon")
        click_button "Deactivate Coupon"
      end

      expect(current_path).to eq(merchant_coupon_path(@hair, @hair20))
      expect(page).to have_content("Status: inactive")

      within "#status-#{@hair20.id}" do
        expect(page).to have_button("Activate Coupon")
      end
    end

    it "displays a button to activate the coupon" do
      visit merchant_coupon_path(@hair, @hair10)
      expect(@hair10.status).to eq("inactive")
      expect(page).to have_content("Status: inactive")

      within "#status-#{@hair10.id}" do
        expect(page).to have_button("Activate Coupon")
        click_button "Activate Coupon"
      end

      expect(current_path).to eq(merchant_coupon_path(@hair, @hair10))
      expect(page).to have_content("Status: active")

      within "#status-#{@hair10.id}" do
        expect(page).to have_button("Deactivate Coupon")
      end
    end
  end
end