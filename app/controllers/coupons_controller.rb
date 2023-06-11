class CouponsController < ApplicationController
  before_action :find_coupon_and_merchant, only: [:show]
  before_action :find_merchant, only: [:index, :new, :create]

  def index
    @coupons = @merchant.coupons
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
  end

  def create
    @coupon1 = Coupon.new(coupon_params)
    if @coupon1.valid?
      @coupon1.save
      flash.notice = "New Coupon has been created!"
      redirect_to merchant_coupons_path(@merchant)
    else
      redirect_to new_merchant_coupon_path(@merchant)
      flash.notice =  "Error: #{@coupon1.errors.full_messages.to_sentence}"
    end
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def coupon_params
    params.permit(:name, :unique_code, :amount_off, :discount_type, :merchant_id)
  end

  def find_coupon_and_merchant
    @coupon = Coupon.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end
end