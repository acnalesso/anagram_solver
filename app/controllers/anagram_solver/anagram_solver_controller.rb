module AnagramSolver
  class AnagramSolverController < ApplicationController

    respond_to :html, :json

    def index
    end

    def create
      respond_to do |f|
        f.json { render json: Time.now.strftime("%2N").to_json, status: 200 }
      end
    end

  end
end
