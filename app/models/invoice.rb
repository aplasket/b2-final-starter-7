class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  belongs_to :coupon, optional: true
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def coupon_discount
    return 0 if coupon.status == "inactive"

    if coupon.discount_type == "percent"
      total_revenue * (coupon.amount_off / 100.0)
    else
      coupon.amount_off
    end
  end

  def grand_total
    return total_revenue if !coupon.present?
    [total_revenue - coupon_discount, 0].max
  end
end