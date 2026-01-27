class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]
  
  def index
    if logged_in?
      @championship = Championship.current
      @user_predictions_count = current_user.predictions.count
      @user_standing = OverallStanding.find_by(user: current_user, championship_id: @championship&.id)
      @user_position = @user_standing&.position
    else
      redirect_to login_path
    end
  end
end
