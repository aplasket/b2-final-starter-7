class CouponsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create]

  def index
    @coupons = @merchant.coupons
  end

  def show
  end

  def new
  end

  def create
    Coupon.create!(name: params[:name],
                  unique_code: params[:unique_code],
                  amount_off: params[:amount_off],
                  discount_type: params[:discount_type],
                  merchant: @merchant)
    flash.notice = "New Coupon has been created!"
    redirect_to merchant_coupons_path(@merchant)
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

end