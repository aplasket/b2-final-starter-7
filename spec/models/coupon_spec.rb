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

end
