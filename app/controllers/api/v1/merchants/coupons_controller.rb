# class Api::V1::Merchants::CouponsController < ApplicationController
#   def index
#     coupons = Coupon.all
#     render json: CouponSerializer.new(coupons), status: :ok
#   end
#
#   def show
#     coupon = Coupon.find(params[:id])
#     render json: CouponSerializer.new(coupon), status: :ok
#   end
#
#   # def create
#   #   merchant = Merchant.find_by(id: coupon_params[:merchant_id])
#   #   return render json: { error: "Merchant not found" }, status: :not_found unless merchant
#   #
#   #   coupon = merchant.coupons.new(coupon_params)
#   #
#   #   if coupon.save
#   #     render json: CouponSerializer.new(coupon), status: :created
#   #   else
#   #     render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
#   #   end
#   # end
#
#   def update
#     coupon = Coupon.find(params[:id])
#     if params[:status] == "activate"
#       updated = Coupon.activate_coupon(coupon)
#     elsif params[:status] == "deactivate"
#       updated = Coupon.deactivate_coupon(coupon)
#     else
#       updated = 
#     end
#     render json: CouponSerializer.new(updated), status: :ok
#   end
#
#   private
#
#   def coupon_params
#     params.permit(:name, :code, :percent_off, :dollars_off,:merchant_id, :active)
#   end
# end
