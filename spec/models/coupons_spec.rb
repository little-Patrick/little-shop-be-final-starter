require "rails_helper"

describe Coupon, type: :model do
  before(:each) do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant) 

    @coupon1a = Coupon.create!(name: "Huge coupon", code: "1a", percent_off: 10, merchant: @merchant1, active: true)
    @coupon1b = Coupon.create!(name: "Huge coupon", code: "1b", dollars_off: 10, merchant: @merchant1, active: true)
    @coupon1c = Coupon.create!(name: "Huge coupon", code: "1c", percent_off: 50, merchant: @merchant1, active: true)
    @coupon1d = Coupon.create!(name: "Huge coupon", code: "1d", dollars_off: 10, merchant: @merchant1, active: true)
    @coupon1e = Coupon.create!(name: "Huge coupon", code: "1e", dollars_off: 10, merchant: @merchant1, active: true)
    @coupon2a = Coupon.create!(name: "Huge coupon", code: "2a", dollars_off: 20, merchant: @merchant2, active: true)
    @coupon3a = Coupon.create!(name: "Huge coupon", code: "3a", percent_off: 14, merchant: @merchant2, active: false)
    @coupon4a = Coupon.create!(name: "Huge coupon", code: "4a", percent_off: 10, merchant: @merchant2, active: false)
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }

    it "#discount_present? validate if no discount is provided" do
      bad_coupon = Coupon.new(name: "bad", code: "123", merchant: @merchant1, active: true)
      expect(bad_coupon).not_to be_valid
    end

    it "validate if both discount options is present" do
      bad_coupon = Coupon.new(name: "bad", code: "123", percent_off: 20, dollars_off: 20,  merchant: @merchant1, active: true)
      expect(bad_coupon).not_to be_valid
    end

    it "reutrns true if one discount option is present" do
      good_coupon = Coupon.new(name: "good", code: "234", percent_off: 20, merchant: @merchant2, active: true)
      expect(good_coupon).to be_valid
    end
        # Active Coupons Parameters
        # present? 
        # there are less than 5 active in the system for a merchant.
    it "validate if no attribute for active/deactive is provided" do
      bad_coupon = Coupon.new(name: "bad", code: "123", percent_off: 20, dollars_off: 20,  merchant: @merchant1, active: true)
      expect(bad_coupon).not_to be_valid
    end

    it "validate if there are 5 in the DB already for that merchant" do
      coupon6 = Coupon.new(name: "Huge coupon", code: "1f", dollars_off: 10, merchant: @merchant1, active: true)
      expect(coupon6).not_to be_valid
    end
  end

  describe "relationships" do
    it { should belong_to :merchant}
  end


  describe "Class Methods" do
  end
end
