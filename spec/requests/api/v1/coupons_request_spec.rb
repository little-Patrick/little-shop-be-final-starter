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
  describe "get all coupons for merchant" do
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
    it "returns all coupons make sure they are the same merchant" do
      get "/api/v1/coupons?merchant_id=#{@merchant1.id}"

      expect(response).to be_successful
      coupons = JSON.parse(response.body, symbolize_names: true)

      coupons[:data].each do |coupon|
        expect(coupon[:attributes][:name]).to be_a(String)
        expect(coupon[:attributes][:code]).to be_a(String)
        expect(coupon[:attributes][:merchant_id]).to eq(@merchant1.id)
      end
    end
    it "returns filtered coupons by status" do
      get "/api/v1/coupons?merchant_id=#{@merchant1.id}&status=true"

      expect(response).to be_successful
      coupons = JSON.parse(response.body, symbolize_names: true)

      coupons[:data].each do |coupon|
        expect(coupon[:attributes][:name]).to be_a(String)
        expect(coupon[:attributes][:code]).to be_a(String)
        expect(coupon[:attributes][:merchant_id]).to eq(@merchant1.id)
        expect(coupon[:attributes][:active]).to eq(true)
      end
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
    it "can create a coupon" do
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
      expect(json[:data][:attributes][:code]).to eq("code")
      expect(json[:data][:attributes][:percent_off]).to eq(19)
      expect(json[:data][:attributes][:merchant_id]).to eq(@merchant2.id)
      expect(json[:data][:attributes][:active]).to eq(false)
    end

    it "returns an error when merchant is not found" do
      body = {
        name: "coupon name",
        code: "code",
        percent_off: 19,
        merchant_id: 999, # Invalid merchant ID
        active: false
      }

      post "/api/v1/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:error]).to eq("Merchant not found")
    end

    it "returns an error when coupon code is not unique" do
      # Create a coupon with the same code as the one we're trying to create
      Coupon.create!(name: "Existing Coupon", code: "code", percent_off: 10, merchant: @merchant2, active: true)

      body = {
        name: "coupon name",
        code: "code", # Duplicate code
        percent_off: 19,
        merchant_id: @merchant2.id,
        active: false
      }

      post "/api/v1/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
    end

    it "returns an error when coupon fails to save due to validation errors" do
      # Force a validation error by providing invalid data (e.g., empty name)
      body = {
        name: "", # Invalid: name cannot be blank
        code: "code",
        percent_off: 19,
        merchant_id: @merchant2.id,
        active: false
      }

      post "/api/v1/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
      expect(json[:errors]).to include("Name can't be blank")
    end
    it "returns an error when no discount is provided" do
      body = {
        name: "coupon name",
        code: "code",
        merchant_id: @merchant2.id,
        active: false
      }

      post "/api/v1/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
    end

    it "returns an error when both discounts are provided" do
      body = {
        name: "coupon name",
        code: "code",
        percent_off: 19,
        dollars_off: 10,
        merchant_id: @merchant2.id,
        active: false
      }

      post "/api/v1/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
    end
  end
   describe "update coupon" do
    it "updates from active to deactive" do
      patch "/api/v1/coupons/#{@coupon1a.id}?status=deactivate"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data][:attributes][:active]).to eq(false)
    end

    it "updates from deactive to active" do
      patch "/api/v1/coupons/#{@coupon4a.id}?status=activate"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data][:attributes][:active]).to eq(true)
    end

    it "updates coupon attributes when no status is provided" do
      body = {
        name: "Updated Coupon Name",
        code: "updated_code",
        percent_off: 25,
        merchant_id: @merchant1.id,
        active: false
      }

      patch "/api/v1/coupons/#{@coupon1a.id}", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data][:attributes][:name]).to eq("Updated Coupon Name")
      expect(json[:data][:attributes][:code]).to eq("updated_code")
      expect(json[:data][:attributes][:percent_off]).to eq(25)
      expect(json[:data][:attributes][:dollars_off]).to eq(nil)
      expect(json[:data][:attributes][:merchant_id]).to eq(@merchant1.id)
      expect(json[:data][:attributes][:active]).to eq(false)
    end

    it "returns an error when updating with invalid data" do
      body = {
        name: "",
        code: "updated_code",
        percent_off: 25,
        merchant_id: @merchant1.id,
        active: false
      }

      patch "/api/v1/coupons/#{@coupon1a.id}", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(422)
    end

    it "returns an error when activating a coupon fails" do
      allow_any_instance_of(Coupon).to receive(:save).and_return(false)

      patch "/api/v1/coupons/#{@coupon4a.id}?status=activate"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
    end

    it "returns an error when deactivating a coupon fails" do
      allow_any_instance_of(Coupon).to receive(:save).and_return(false)

      patch "/api/v1/coupons/#{@coupon1a.id}?status=deactivate"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
    end
  end

   describe "more than 5 active" do
     it "can't have more than 5 active" do
       body = {
          name: "new name",
          code: "1a2b",
          percent_off: 19,
          merchant_id: @merchant1.id,
          active: true
       }

      post "/api/v1/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
     end
   end
end


