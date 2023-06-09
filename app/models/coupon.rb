class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :unique_code,
                        :discount_type,
                        :status,
                        :merchant_id

  belongs_to :merchant
  belongs_to :invoice, optional: true

  enum discount_type: [:percent, :dollar]
  enum status: [:active, :inactive]
end
