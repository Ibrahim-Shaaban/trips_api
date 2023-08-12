class UpdateTripLocationWorker
    include Sidekiq::Worker
  
    sidekiq_options retry: 3
  
    def perform(trip_id, longitude, latitiude)
        Location.create(trip_id: trip_id, longitude: longitude, latitude: latitiude)
    end
  end