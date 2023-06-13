require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to(:coupon).optional }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  describe "instance methods" do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @hair10 = Coupon.create!(name: "10% off", unique_code: "HAIR10OFF", amount_off: 10, discount_type: 0, merchant_id: @merchant1.id, status: 0)
      @love10 = Coupon.create!(name: "$10 off", unique_code: "LOVE10", amount_off: 10, discount_type: 1, merchant_id: @merchant1.id, status: 0)
      @hairswirl = Coupon.create!(name: "swirls", unique_code: "SWIRLS", amount_off: 6, discount_type: 1, merchant_id: @merchant1.id) #default inactive status

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @hair10.id)
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)

      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @love10.id)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)

      @invoice_3 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @love10.id)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_8.id, quantity: 3, unit_price: 5, status: 1)
      @transaction3 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)

      @invoice_4 = Invoice.create!(customer_id: @customer_1.id, status: 1, coupon_id: @hairswirl.id) #inactive coupon, no discount
      @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_1.id, quantity: 2, unit_price: 10, status: 1)
      @trasaction4 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_4.id)
    end

    it "total_revenue" do
      expect(@invoice_1.total_revenue).to eq(95)
    end

    it "#grand_total" do
      expect(@invoice_1.grand_total).to eq(85.5)
      expect(@invoice_2.grand_total).to eq(0)
      expect(@invoice_3.grand_total).to eq(5)
      expect(@invoice_4.grand_total).to eq(20)
    end
  end
end
