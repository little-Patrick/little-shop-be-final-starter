class Api::V1::CouponsController < ApplicationController
  def index
    coupons = Coupon.all

    # if params[:sorted].present? && params[:sorted] == "price"
    #   coupons = Coupon.sort_by_price
    # end

    render json: CouponSerializer.new(coupons), status: :ok
  end

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def create
    coupon = Coupon.create!(coupon_params) # safe to use create! here because our exception handler will gracefully handle exception
    render json: CouponSerializer.new(coupon), status: :created
  end

  def update
    coupon = Coupon.find(params[:id])
    # if !coupon_params[:merchant_id].nil?
    #   merchant = Merchant.find(coupon_params[:merchant_id])
    # end
    # coupon.update(coupon_params)
    # coupon.save

    render json: CouponSerializer.new(coupon), status: :ok
  end

  private

  def coupon_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
