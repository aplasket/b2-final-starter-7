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

  def grand_total
    return total_revenue if !coupon.present?

    if coupon.discount_type == "percent"
      total_revenue - (total_revenue * (coupon.amount_off / 100.0.to_f))
    elsif coupon.discount_type == "dollars"
      g_total = total_revenue - coupon.amount_off
      if g_total < 0
        0
      else
        g_total
      end
    end
  end
end