class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :unique_code,
                        :amount_off,
                        :discount_type,
                        :status,
                        :merchant_id

  belongs_to :merchant
  has_many :invoices
  
  enum discount_type: [:percent, :dollars]
  enum status: [:active, :inactive]
end
