class Api::V1::DriversController < Api::BaseApi
  before_action :set_driver, only: %i[ show update destroy ]

  # GET /drivers
  def index
    @drivers = Driver.all

    render json: @drivers
  end

  # GET /drivers/1
  def show
    render json: @driver
  end

  def sign_in
    begin
      login_data = Driver.handle_login(params[:email], params[:password])
      render json: login_data
    rescue => e
      render json: e, status: :unauthorized
    end

  end

  # POST /drivers
  def create
    @driver = Driver.create_new_one(params[:name], params[:email], params[:password])

    if @driver.save
      render json: 'created successfully', status: :created
    else
      render json: @driver.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drivers/1
  def update
    if @driver.update(driver_params)
      render json: @driver
    else
      render json: @driver.errors, status: :unprocessable_entity
    end
  end

  # DELETE /drivers/1
  def destroy
    @driver.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def driver_params
      params.require(:driver).permit(:name, :email, :password)
    end
end
