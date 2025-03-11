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
      get "/api/v1/coupons"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      first_coupon = json[:data].first
      expect(first_coupon[:attributes][:name]).to eq("Huge coupon")
      expect(first_coupon[:attributes][:code]).to eq("1a")
      expect(first_coupon[:attributes][:dollars_off]).to eq(nil)
      expect(first_coupon[:attributes][:percent_off]).to eq(10)
      expect(first_coupon[:attributes][:merchant_id]).to eq(@merchant1.id)
      expect(first_coupon[:attributes][:active]).to eq(true)
    end
  end

  describe "get one coupon" do
    it "returns the right coupon" do
      get "/api/v1/coupons/#{@coupon1e.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name]).to eq("Huge coupon")
      expect(json[:data][:attributes][:code]).to eq("1e")
      expect(json[:data][:attributes][:dollars_off]).to eq(10)
      expect(json[:data][:attributes][:percent_off]).to eq(nil)
      expect(json[:data][:attributes][:merchant_id]).to eq(@merchant1.id)
      expect(json[:data][:attributes][:active]).to eq(true)
    end
  end

  describe "create a coupon" do
    xit "can create a coupon" do
      body = {
        name: "coupon name",
        code: "code",
        percent_off: 19,
        merchant_id: @merchant2.id,
        active: false
      }

      post "/api/v1/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:data][:attributes][:name]).to eq("coupon name")
      expect(json[:data][:attributes][:description]).to eq("code")
      expect(json[:data][:attributes][:unit_price]).to eq(19)
      expect(json[:data][:attributes][:unit_price]).to eq(@merchant2.id)
      expect(json[:data][:attributes][:unit_price]).to eq(false)
    end
  end

  describe "update coupon" do
    it "updates from active to deactive" do
      patch "/api/v1/coupons/#{@coupon1a.id}?status=deactivate" 
      json = JSON.parse(response.body, symbolize_names: true)
      puts response.body
      expect(response).to be_successful
      expect(json[:data][:attributes][:active]).to eq(false)
    end
    
    it "updates from deactive to active" do
      patch "/api/v1/coupons/#{@coupon4a.id}?status=activate" 
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(json[:data][:attributes][:active]).to eq(true)
    end
  end
end
