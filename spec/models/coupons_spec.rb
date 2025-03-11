require "rails_helper"

describe Merchant, type: :model do
  before(:each) do
    @merchant1 = create!(:merchant)
    @merchant2 = create!(:merchant) 

    @coupon1a = Coupon.create!(name: "Huge coupon", code: "1a", percent_off: 10, merchant_id: @merchant1, acitive: true)
    @coupon1b = Coupon.create!(name: "Huge coupon", code: "1b", dollars_off: 10, merchant_id: @merchant1, acitive: true)
    @coupon1c = Coupon.create!(name: "Huge coupon", code: "1c", percent_off: 50, merchant_id: @merchant1, acitive: true)
    @coupon1d = Coupon.create!(name: "Huge coupon", code: "1d", dollars_off: 10, merchant_id: @merchant1, acitive: true)
    @coupon1e = Coupon.create!(name: "Huge coupon", code: "1e", dollars_off: 10, merchant_id: @merchant1, acitive: true)
    @coupon2a = Coupon.create!(name: "Huge coupon", code: "2a", dollars_off: 20, merchant_id: @merchant2, acitive: true)
    @coupon3a = Coupon.create!(name: "Huge coupon", code: "3a", percent_off: 14, merchant_id: @merchant2, acitive: false)
    @coupon4a = Coupon.create!(name: "Huge coupon", code: "4a", percent_off: 10, merchant_id: @merchant2, acitive: false)
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:dollars_off) }
    it { should validate_presence_of(:merchant_id) }

    it "#discount_present? validate if no discount is provided" do
      bad_coupon = Coupon.create!(name: "bad", code: "123", merchant_id: @merchant1, active: true)
      expect(bad_coupon).not_to be_valid
    end

    it "validate if both discount options is present" do
      bad_coupon = Coupon.create!(name: "bad", code: "123", percent_off: 20, dollars_off: 20,  merchant_id: @merchant1, active: true)
      expect(bad_coupon).not_to be_valid
    end

    it "reutrns true if one discount option is present" do
      good_coupon = Coupon.create!(name: "good", code: "234", merchant_id: @merchant1, active: true)
      expect(good_coupon).to be_valid
    end
        # Active Coupons Parameters
        # present? 
        # there are less than 5 active in the system for a merchant.
    it "#active_coupons? validate if Active Coupons Parameters" do
      expect(@coupon1a).to be_valid
    end

    it "validate if no attribute for active/deactive is provided" do
      bad_coupon = Coupon.create!(name: "bad", code: "123", percent_off: 20, dollars_off: 20,  merchant_id: @merchant1, active:)
      expect(bad_coupon).not_to be_valid
    end

    it "validate if there are 5 in the DB already for that merchant" do
      @coupon6 = Coupon.create!(name: "Huge coupon", code: "1f", dollars_off: 10, merchant_id: @merchant1, acitive: true)
      expect(@couon6).not_to be_valid
    end
  end

  describe "relationships" do
    it { should belong_to :merchant}
  end


  describe "Class Methods" do
  end
end
