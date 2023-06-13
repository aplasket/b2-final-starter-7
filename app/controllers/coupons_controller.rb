class CouponsController < ApplicationController
  before_action :find_coupon_and_merchant, only: [:show, :edit, :update]
  before_action :find_merchant, only: [:index, :new, :create]
  before_action :invoice_check_for_coupon, only: [:update]

  def index
    @coupons = @merchant.coupons
    @active_coupons = @merchant.coupons.active
    @inactive_coupons = @merchant.coupons.inactive
    @holidays = HolidaySearch.new.new_holiday(3)
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

  def edit
  end

  def update
    if params[:change] == "inactive" && @merchant.active_threshold_reached?
      redirect_to merchant_coupons_path(@merchant)
      flash.notice = "Error: You cannot have more than 5 active coupons, please deactivate one first"
    elsif params[:change] == "active"
      @coupon.update(status: "inactive")
      redirect_to merchant_coupon_path(@merchant, @coupon)
    else
      @coupon.update(status: "active")
      redirect_to merchant_coupon_path(@merchant, @coupon)
    end
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def coupon_params
    params.permit(:name, :unique_code, :amount_off, :discount_type, :merchant_id, :status)
  end

  def find_coupon_and_merchant
    @coupon = Coupon.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def invoice_check_for_coupon
    @coupon = Coupon.find(params[:id])
    @invoice = Invoice.find_by(coupon_id: @coupon.id)
    if @coupon.invoice_in_progress?
      flash[:alert] = "Error: You cannot deactivate a coupon while an invoice is in process"
      redirect_to merchant_coupon_path(@merchant, @coupon)
    end
  end
end