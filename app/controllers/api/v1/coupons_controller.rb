class Api::V1::CouponsController < ApplicationController
  def index
    if params[:merchant_id]
      coupons = Coupon.find_merchants_coupons(params[:merchant_id])
    elsif params[:merchant_id] && params[:status]
      coupons = Coupons.filter_merchants_coupons(params[:merchant_id], params[:status])
    else
      coupons = Coupon.all
    end
    render json: CouponSerializer.new(coupons), status: :ok
  end

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def create
    merchant = Merchant.find_by(id: coupon_params[:merchant_id])
    return render json: { error: "Merchant not found" }, status: :not_found unless merchant

    if merchant.coupons.where(active: true).count >= 5
      return render json: { error: "This merchant already has 5 active coupons" }, status: :unprocessable_entity
    end
    if merchant.coupons.exists?(code: coupon_params[:code])
      return render json: { error: "Coupon code must be unique" }, status: :unprocessable_entity
    end

    coupon = merchant.coupons.new(coupon_params)

    if coupon.save
      render json: CouponSerializer.new(coupon), status: :created
    else
      render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

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
