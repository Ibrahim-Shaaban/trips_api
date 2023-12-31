require 'rails_helper'

RSpec.describe Api::V1::TripsController, type: :controller do

    describe 'POST#create' do
        let(:driver) { create(:driver) }
        let(:auth_token) { JsonWebToken.encode(id: driver.id) }
    
        context 'when no token is sent' do
          it 'rejects the request' do
            post :create, params: { name: 'test trip' }
            expect(response).to have_http_status(:unauthorized)
            expect(response.body).to eq("unauthenticated driver")
          end
        end
    
        context 'when a valid data is provided' do
          it 'create new trip' do
            request.headers['Authorization'] = "Bearer #{auth_token}"
            post :create, params: { name: 'test trip' }
            expect(response).to have_http_status(:success)
            expect(response.body).to eq("created successfully")
          end
        end
    

    end

    describe 'GET#index' do
      let(:driver) { create(:driver) }
      let(:auth_token) { JsonWebToken.encode(id: driver.id) }
  
      context 'when no token is sent' do
        it 'rejects the request' do
          get :index
          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq('unauthenticated driver')
        end
      end
  
      context 'when a valid token is provided' do
        it 'gets the driver trips' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          trips = create_list(:trip, 3, driver: driver)
  
          get :index
          expect(response).to have_http_status(:success)
          json_response = JSON.parse(response.body)
          expect(json_response['data'].size).to eq(3)
        end
      end
    end

    describe 'GET#show' do
      let(:driver) { create(:driver) }
      let(:auth_token) { JsonWebToken.encode(id: driver.id) }
  
      context 'when no token is sent' do
        it 'rejects the request' do
          get :show, params: {id: 1}
          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq('unauthenticated driver')
        end
      end

      context 'when a valid token is provided but wrong trip id' do
        it 'return error' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          params = {id: 'not valid id'}
          get :show, params: params
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq("Trip not found")
        end
      end

  
      context 'when a valid token is provided with valid trip id' do
        it 'gets the driver trip' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          trip = create(:trip, driver: driver)
          params = {id: trip.id}
          get :show, params: params
          expect(response).to have_http_status(:success)
          json_response = JSON.parse(response.body)
          expect(json_response['data']['id']).to eq(trip.id.to_s)
        end
      end
    end

    describe 'DELETE#destroy' do
      let(:driver) { create(:driver) }
      let(:auth_token) { JsonWebToken.encode(id: driver.id) }
  
      context 'when no token is sent' do
        it 'rejects the request' do
          delete :destroy, params: {id: 1}
          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq('unauthenticated driver')
        end
      end

      context 'when a valid token is provided but wrong trip id' do
        it 'return error' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          params = {id: 'not valid id'}
          delete :destroy, params: params
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq("Trip not found")
        end
      end

  
      context 'when a valid token is provided with valid trip id' do
        it 'delete the driver trip' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          trip = create(:trip, driver: driver)
          params = {id: trip.id}
          delete :destroy, params: params
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq("deleted successfully")
        end
      end
    end

    describe 'PUT#update' do
      let(:driver) { create(:driver) }
      let(:auth_token) { JsonWebToken.encode(id: driver.id) }
  
      context 'when no token is sent' do
        it 'rejects the request' do
          put :update, params: {id: 1}
          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq('unauthenticated driver')
        end
      end

      context 'when a valid token is provided but wrong trip id' do
        it 'return error' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          params = {id: 'not valid id'}
          put :update, params: params
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq("Trip not found")
        end
      end

  
      context 'when a valid token is provided with valid trip id' do
        it 'update the driver trip' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          trip = create(:trip, driver: driver)
          updated_name = "updated name"
          params = {id: trip.id, trip: {name: updated_name}}
          put :update, params: params
          expect(response).to have_http_status(:success)
          json_response = JSON.parse(response.body)
          expect(json_response['data']['attributes']['name']).to eq(updated_name)
        end
      end
    end

    describe 'PUT#complete' do
      let(:driver) { create(:driver) }
      let(:auth_token) { JsonWebToken.encode(id: driver.id) }
  
      context 'when no token is sent' do
        it 'rejects the request' do
          put :complete, params: {id: 1}
          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq('unauthenticated driver')
        end
      end

      context 'when a valid token is provided but wrong trip id' do
        it 'return error' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          params = {id: 'not valid id'}
          put :complete, params: params
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq("Trip not found")
        end
      end

  
      context 'when a valid token is provided with valid trip id' do
        it 'make the trip is completed' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          trip = create(:trip, driver: driver)
          params = {id: trip.id}
          put :complete, params: params
          expect(response).to have_http_status(:success)
          expect(response.body).to eq('successfully completed')
          expect(trip.reload.status).to eq('completed')
          
        end
      end

      context 'when a valid token is provided with valid trip id but trip is already completed' do
        it 'return error' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          trip = create(:trip, driver: driver, status: "completed")
          params = {id: trip.id}
          put :complete, params: params
          expect(response).to have_http_status(:bad_request)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('trip is aleady completed')
          
        end
      end
    end

    describe 'PUT#update_location' do
      let(:driver) { create(:driver) }
      let(:auth_token) { JsonWebToken.encode(id: driver.id) }
  
      context 'when no token is sent' do
        it 'rejects the request' do
          put :update_location, params: {id: 1}
          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq('unauthenticated driver')
        end
      end

      context 'when a valid token is provided but wrong trip id' do
        it 'return error' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          params = {id: 'not valid id'}
          put :update_location, params: params
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq("Trip not found")
        end
      end

  
      context 'when a valid token is provided with valid trip id' do
        it 'add location to trip' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          trip = create(:trip, driver: driver)
          params = {id: trip.id, latitude: 40.7128,longitude: -74.0060}
          put :update_location, params: params
          expect(response).to have_http_status(:success)
          last_trip_location = trip.locations.last
          expect(last_trip_location.latitude).to eq(40.7128)
          expect(last_trip_location.longitude).to eq(-74.0060)
        end
      end

      context 'when a valid token is provided with valid trip id but location is already existed' do
        it 'return error' do
          request.headers['Authorization'] = "Bearer #{auth_token}"
          trip = create(:trip, driver: driver)
          location = create(:location, trip:trip, latitude: 40.7128,longitude: -74.0060)
          params = {id: trip.id, latitude: 40.7128,longitude: -74.0060}
          put :update_location, params: params
          expect(response).to have_http_status(:conflict)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('data is aleady existed')
        end
      end
    end

end