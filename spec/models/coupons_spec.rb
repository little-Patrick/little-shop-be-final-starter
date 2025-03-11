require "rails_helper"

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:dollars_off) }
    it { should validate_presence_of(:merchant_id) }

    it "#discount_present? returns false if no discount is provided" do
    end

    it "reutrns true if one discount option is present" do
    end

    it "returns false if both discount options is present" do
    end

    it "has error message if false" do
    end
        # Active Coupons Parameters
        # present? 
        # there are less than 5 active in the system for a merchant.
    it "#active_coupons? returns true if Active Coupons Parameters" do
    end

    it "returns false if no attribute is provided" do
    end

    it "returns false if there are 5 in the DB already for that merchant" do
    end
  end

  describe "relationships" do
    it { should belong_to :merchant}
  end


  describe "Class Methods" do
  end
end
