class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices, dependent: :nullify 

  validates :name, presence: true
  validates :code, presence: true
  validate :discount_present?
  validate :active_coupons?, unless: :deactivating?
  
  def discount_present?
    if dollars_off.blank? && percent_off.blank?
      errors.add(:field, "Must contain a discount")
    elsif dollars_off.present? && percent_off.present?
      errors.add(:field, "Must contain only one discount")
    end
  end
  
  def active_coupons?
    active_count = Coupon.where(merchant_id: merchant_id, active: true).count
    if active_count >= 5
      errors.add(:active, "There cannot be more than 5 active coupons")
    end
  end

  def activate
    self.active = true
  end

  def deactivate
    self.active = false
  end

  def deactivating?
    self.active == false
  end

  def self.find_merchants_coupons(merchant_id)
    where(merchant_id: merchant_id)
  end

  def self.filter_merchants_coupons(merchant_id, status)
    where(merchant_id: merchant_id, active: status)
  end

end
