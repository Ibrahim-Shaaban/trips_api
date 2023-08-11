require 'rails_helper'

RSpec.describe Trip, type: :model do
  describe '.create_new_one' do
    let(:current_driver) { create(:driver) }
    let(:name) { 'My Trip' }

    it 'creates a new trip associated with the current driver' do
      trip = Trip.create_new_one(current_driver, name)
      
      expect(trip.name).to eq(name)
      expect(trip.driver_id).to eq(current_driver.id)
    end
  end
end
