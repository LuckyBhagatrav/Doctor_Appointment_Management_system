module Api
  class HomeController < ApplicationController
    respond_to :json
    before_action :authenticated_user!

    def index
      render json: { status: 200, success: true, message: "Home page"}, status: :ok
    end
  end
end
