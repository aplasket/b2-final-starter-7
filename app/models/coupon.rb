class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :discount_type,
                        :status,
                        :merchant_id

  validates :amount_off, numericality: { only_integer: true, greater_than: 0 }
  validates :unique_code, uniqueness: { case_sensitive: false }

  belongs_to :merchant
  has_many :invoices

  enum discount_type: [:percent, :dollars]
  enum status: [:active, :inactive]
end
