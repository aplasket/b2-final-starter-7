require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
  end

  describe "validations" do
    let!(:merchant) { Merchant.create!(name: "merchant name inserted", status: 0) }
    subject { Coupon.new(name: "Name inserted", amount_off: 0, discount_type: 0, merchant_id: merchant.id) }
    it { should validate_uniqueness_of(:unique_code).case_insensitive}
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:amount_off) }
    it { should validate_presence_of(:discount_type) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe "instance methods" do
    before(:each) do
      @hair = Merchant.create!(name: "Hair Care")
      @hair10 = Coupon.create!(name: "10% off", unique_code: "HAIR10OFF", amount_off: 10, discount_type: 0, merchant_id: @hair.id, status: 0)
      @hair20 = Coupon.create!(name: "20% off", unique_code: "HAIR20OFF", amount_off: 20, discount_type: 0, merchant_id: @hair.id)
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
      @invoice_5 = Invoice.create!(customer_id: @customer_3.id, status: 1, coupon_id: @hair10.id) #c3 has 0 successful transactions

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

    describe "count_used" do
      it "count how many times this coupon (code) has been used; successful transactions only" do
        expect(@hair10.count_used).to eq(3)
        expect(@hair20.count_used).to eq(0)
      end
    end

    describe "#invoice_in_progress?" do
      it "searches all invoice status and returns true if any are in progress" do
        expect(@hair10.invoice_in_progress?).to eq(true)
      end
    end
  end
end
