require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it { should belong_to(:merchant) }
  it { should have_many(:invoices) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:unique_code) }
  it { should validate_numericality_of(:amount_off) }
  it { should validate_presence_of(:discount_type) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:merchant_id) }
end
