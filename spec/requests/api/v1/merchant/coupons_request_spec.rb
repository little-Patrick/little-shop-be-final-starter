require "rails_helper"

RSpec.describe "Coupons Endpoints" do
  before :each do
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
  describe "get all coupons" do
    it "returns all coupons" do
      get "/api/v1/merchants/coupons"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true).first
      expect(json[:data][:attributes][:name]).to eq("Huge coupon")
      expect(json[:data][:attributes][:code]).to eq("1b")
      expect(json[:data][:attributes][:dollars_off]).to eq(nil)
      expect(json[:data][:attributes][:percent_off]).to eq(10)
      expect(json[:data][:attributes][:merchant_id]).to eq(@merchant1.id)
      expect(json[:data][:attributes][:active]).to eq(true)
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
