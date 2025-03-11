class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices, dependent: :nullify 

  validates :name, presence: true
  validates :code, presence: true
  validates :merchant_id, presence: true
  validates :discount_present?
  validates :active_coupons?
  
  def discount_present?
    if dollars_off.blank? && percent_off.blank?
      ErrorSerializer.format_invalid_search_response
    elsif dollars_off.present? && percent_off.present?
      ErrorSerializer.format_invalid_search_response
    else 
      true
    end
  end
  
  def active_coupons?
  end
end
