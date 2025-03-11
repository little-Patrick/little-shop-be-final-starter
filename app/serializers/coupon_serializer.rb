class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :percent_off, :dollars_off, :merchant_id, :active
end

