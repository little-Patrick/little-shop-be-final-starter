require "rails_helper"

RSpec.describe "Coupons Endpoints" do
  before :each do
    @merchant1 = Merchant.create!(name: "Crate and Barrel")
    @merchant2 = Merchant.create!(name: "Pier 1")
    @merchant3 = Merchant.create!(name: "crater lake artists")
    @merchant4 = Merchant.create!(name: "Plates R Us")
    
    @coupon1a = Coupon.create!(name: "Huge coupon", code: "1a", percent_off: "10", merchant_id: @merchant1, acitive: true)
    @coupon1b = Coupon.create!(name: "Huge coupon", code: "1b", dollars_off: "10", merchant_id: @merchant1, acitive: true)
    @coupon1c = Coupon.create!(name: "Huge coupon", code: "1c", percent_off: "50", merchant_id: @merchant1, acitive: true)
    @coupon1d = Coupon.create!(name: "Huge coupon", code: "1d", dollars_off: "10", merchant_id: @merchant1, acitive: false)
    @coupon2a = Coupon.create!(name: "Huge coupon", code: "2a", dollars_off: "20", merchant_id: @merchant2, acitive: true)
    @coupon3a = Coupon.create!(name: "Huge coupon", code: "3a", percent_off: "14", merchant_id: @merchant2, acitive: true)
    @coupon4a = Coupon.create!(name: "Huge coupon", code: "4a", percent_off: "10", merchant_id: @merchant2, acitive: true)
  end
  describe "get all coupons" do
    it "returns all coupons" do
      get "/api/v1/merchants/coupons"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("Crate and Barrel")
    end
  #
  #   it "returns an empty data object if no merchant is found" do
  #     get "/api/v1/merchants/find?name=NOMATCH"
  #
  #     expect(response).to be_successful
  #     json = JSON.parse(response.body, symbolize_names: true)
  #     expect(json[:data]).to eq({})
  #   end
  #
  #   it "returns an error if name is missing" do
  #     get "/api/v1/merchants/find"
  #     expect(response).to_not be_successful
  #     json = JSON.parse(response.body, symbolize_names: true)
  #     expect(json[:errors][0]).to eq("invalid search params")
  #   end
  #
  #   it "returns an error if name is blank" do
  #     get "/api/v1/merchants/find?name="
  #     expect(response).to_not be_successful
  #     json = JSON.parse(response.body, symbolize_names: true)
  #     expect(json[:errors][0]).to eq("invalid search params")
  #   end
  # end
  #
  # describe "find all merchants" do
  #   it "should return all merchants that satisfy search query" do
  #     get "/api/v1/merchants/find_all?name=ate"
  #
  #     expect(response).to be_successful
  #     json = JSON.parse(response.body, symbolize_names: true)
  #     merchant_names = json[:data].map { |element| element[:attributes][:name] }
  #     expect(merchant_names).to match_array(["Crate and Barrel", "crater lake artists", "Plates R Us"])
  #   end
  #
  #   it "returns an error if name is blank" do
  #     get "/api/v1/merchants/find_all?name="
  #     expect(response).to_not be_successful
  #     json = JSON.parse(response.body, symbolize_names: true)
  #     expect(json[:errors][0]).to eq("invalid search params")
  #   end
  # end
  end
end
