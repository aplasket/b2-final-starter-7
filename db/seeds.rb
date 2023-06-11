# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
InvoiceItem.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Item.destroy_all
Customer.destroy_all
Merchant.destroy_all

Rake::Task["csv_load:all"].invoke

@hair = Merchant.create!(name: "Hair Care")
@hair10 = Coupon.create!(name: "10% off", unique_code: "HAIR10OFF", amount_off: 10, discount_type: 0, merchant_id: @hair.id)
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