class Api::V1::CouponsController < ApplicationController
  def index
    coupons = Coupon.all
    render json: CouponSerializer.new(coupons), status: :ok
  end

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  # def create
  #   merchant = Merchant.find_by(id: coupon_params[:merchant_id])
  #   return render json: { error: "Merchant not found" }, status: :not_found unless merchant
  #
  #   coupon = merchant.coupons.new(coupon_params)
  #
  #   if coupon.save
  #     render json: CouponSerializer.new(coupon), status: :created
  #   else
  #     render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end
  def update
    coupon = Coupon.find(params[:id])

    if params[:status] == "activate"
      coupon.activate
      if coupon.save
        render json: CouponSerializer.new(coupon), status: :ok
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    elsif params[:status] == "deactivate"
      coupon.deactivate
      if coupon.save
        render json: CouponSerializer.new(coupon), status: :ok
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    else
      if coupon.update(coupon_params)
        render json: CouponSerializer.new(coupon), status: :ok
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :percent_off, :dollars_off,:merchant_id, :active)
  end
end
