class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :unique_code,
                        :type,
                        :merchant_id

  belongs_to :merchant
  belongs_to :invoice, optional: true

  enum type: [:percent, :dollar]
end
