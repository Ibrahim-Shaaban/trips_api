class Api::V1::TripsController < Api::BaseApi
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :record_is_existed_before
  before_action :authorized
  before_action :set_trip, only: %i[ show update destroy complete update_location]

  # GET /trips
  def index
    @trips = current_driver.trips.order(created_at: :desc)

    render json: TripSerializer.new(@trips).serializable_hash
  end

  # GET /trips/1
  def show
    render json: TripSerializer.new(@trip).serializable_hash
  end

  # POST /trips
  def create
    @trip = Trip.create_new_one(current_driver, params[:name])

    if @trip.save
      render json: "created successfully", status: :created
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    if @trip.update(trip_params)
      render json: TripSerializer.new(@trip).serializable_hash
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  def complete
    if @trip.status == 'completed'
      return render json: { error: "trip is aleady completed" }, status: :bad_request
    end
    @trip.status = "completed"
    @trip.save
    render  json: "successfully completed"
  end

  def update_location
    @location = Location.new(trip: @trip, latitude: params[:latitude], longitude: params[:longitude])
    if @location.save
      render json: "location updated successfully", status: :created
    else
      render json: @location.errors, status: :unprocessable_entity
    end
    # another solution is to use background job worker to handle incoming requests
    # UpdateTripLocationWorker.perform_async(@trip.id, params[:latitude], params[:longitude])
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
    render json: "deleted successfully", status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = current_driver.trips.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trip_params
      params.require(:trip).permit(:name, :latitude, :longitude)
    end

    def record_not_found
      render json: { error: "Trip not found" }, status: :not_found
    end
    
    def record_is_existed_before
      render json: {error: "data is aleady existed"}, status: :conflict
    end
end
