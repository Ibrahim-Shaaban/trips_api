require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:payload) { { user_id: 1 } }
  let(:exp) { 24.hours.from_now }
  let(:token) { JsonWebToken.encode(payload, exp) }

  describe 'encode' do
    it 'encodes a payload and returns a JWT token' do
      expect(token).to be_present
    end
  end

  describe 'decode' do
    context 'when the token is valid' do
      it 'decodes the token and returns the payload' do
        decoded_payload = JsonWebToken.decode(token)
        expect(decoded_payload).to eq(payload.with_indifferent_access)
      end
    end

    context 'when the token is invalid' do
      let(:invalid_token) { 'invalid_token' }

      it 'returns false' do
        expect(JsonWebToken.decode(invalid_token)).to be_falsey
      end
    end
  end
end