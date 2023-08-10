module Api
  class Api::BaseApi < ApplicationController

    # implement token auth logic
    def auth_header
      request.headers['Authorization']
    end

    def token
      auth_header.split(' ')[1]
    end

    def decoded_token
      if auth_header
        JsonWebToken.decode(token)
      end
    end
    def current_driver
      if decoded_token
        driver_id = decoded_token['id']
        @driver = Driver.find_by(id: driver_id)
        @driver.present? ? @driver : false
      end
    end

    def logged_in?
      !!current_driver
    end

    def authorized
      render json: "unauthenticated driver", status: :unauthorized unless logged_in?
    end

  end
end