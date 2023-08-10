require 'rails_helper'

RSpec.describe Api::V1::DriversController, type: :controller do

  describe "POST #create" do
    context "given valid parameters" do
      let(:params) { { name: "third driver", email: "third@example.com", password: "password" } }

      it "creates a new driver and returns HTTP status :created" do
        expect {
          post :create, params: params
        }.to change(Driver, :count).by(1)

        expect(response).to have_http_status(:created)

      end
    end

    context "given invalid parameters" do
      let(:params) { { name: "", email: "", password: "" } }

      it "does not create a new driver and returns HTTP status :unprocessable_entity" do
        expect {
          post :create, params: params
        }.not_to change(Driver, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe "POST #sign_in" do
    let(:driver) { create(:driver,name:"second driver", email: "second@example.com", password: "password") }

    context "given valid email and password" do
      it "returns a token and expiration date" do
        post :sign_in, params: { email: driver.email, password: "password" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("token", "expires_at")
      end
    end

    context "given invalid email" do
      it "returns an unauthorized status" do
        post :sign_in, params: { email: "invalid_email@example.com", password: "password" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "given invalid password" do
      it "returns an unauthorized status" do
        post :sign_in, params: { email: driver.email, password: "invalid_password" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end