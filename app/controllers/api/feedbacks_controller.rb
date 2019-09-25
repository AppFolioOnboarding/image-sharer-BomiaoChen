module Api
  class FeedbacksController < ApplicationController
    def create
      render json: { message: 'thank you for feedback' }, status: :ok
    end
  end
end
