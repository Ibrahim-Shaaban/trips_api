class Api::V1::TripsController < Api::BaseApi
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authorized
  before_action :set_trip, only: %i[ show update destroy ]

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

  # DELETE /trips/1
  def destroy
    @trip.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = current_driver.trips.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trip_params
      params.require(:trip).permit(:name)
    end

    def record_not_found
      render json: { error: "Trip not found" }, status: :not_found
    end
end
