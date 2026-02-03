module PredictionsHelper
    def calculate_match_points(prediction, match)
      return 0 unless match.finished? && prediction
      
      # Placar exato
      if prediction.home_score == match.home_score && prediction.away_score == match.away_score
        return 10
      end
      
      # Acertou o resultado (vitória/empate/derrota)
      predicted_result = prediction_result(prediction.home_score, prediction.away_score)
      actual_result = prediction_result(match.home_score, match.away_score)
      
      if predicted_result == actual_result
        return 5
      end
      
      0
    end
    
    private
    
    def prediction_result(home_score, away_score)
      if home_score > away_score
        :home_win
      elsif away_score > home_score
        :away_win
      else
        :draw
      end
    end
  end