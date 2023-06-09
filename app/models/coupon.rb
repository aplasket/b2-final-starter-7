class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :unique_code,
                        :discount_type,
                        :status,
                        :merchant_id

  validates :amount_off, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :merchant
  has_many :invoices

  enum discount_type: [:percent, :dollars]
  enum status: [:active, :inactive]
end
