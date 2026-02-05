class ScoreCalculatorService
  def initialize(match)
    @match = match
    @round = match.round
    @championship = @round.championship
  end
  
  def calculate
    return unless @match.finished?
    
    # Limpar pontuações anteriores deste jogo
    clear_previous_scores
    
    # Calcular pontos para cada usuário que fez previsão
    @match.predictions.each do |prediction|
      points = calculate_points(prediction)
      update_user_scores(prediction.user, points)
    end
    
    # Recalcular posições da rodada
    recalculate_round_positions
    
    # Recalcular posições gerais
    recalculate_overall_positions
  end
  
  private
  
  def clear_previous_scores
    # Recalcular do zero todos os jogos finalizados da rodada
    @round.round_scores.destroy_all
    
    # Recalcular pontuação geral do zero
    @championship.overall_standings.destroy_all
    
    # Recalcular TODOS os jogos finalizados desta rodada
    @round.matches.finished_matches.each do |match|
      next if match == @match # Pular o jogo atual (será calculado depois)
      match.predictions.each do |prediction|
        points = calculate_match_points(match, prediction)
        add_user_scores(prediction.user, points)
      end
    end
  end
  
  def calculate_match_points(match, prediction)
    return { points: 0, exact_score: false, correct_result: false } unless match.result_set?
    
    points = 0
    exact_score = false
    correct_result = false
    
    # Verificar placar exato
    if prediction.home_score == match.home_score && 
       prediction.away_score == match.away_score
      points = match.involves_favorite? ? 20 : 10
      exact_score = true
      correct_result = true
    # Verificar resultado correto (V/E/D)
    elsif same_result_for_match?(match, prediction)
      points = match.involves_favorite? ? 10 : 5
      correct_result = true
    end
    
    { points: points, exact_score: exact_score, correct_result: correct_result, match: match }
  end
  
  def calculate_points(prediction)
    calculate_match_points(@match, prediction)
  end
  
  def same_result?(prediction)
    same_result_for_match?(@match, prediction)
  end
  
  def same_result_for_match?(match, prediction)
    match_result = get_result(match.home_score, match.away_score)
    prediction_result = get_result(prediction.home_score, prediction.away_score)
    match_result == prediction_result
  end
  
  def get_result(home, away)
    return :home_win if home > away
    return :away_win if away > home
    :draw
  end
  
  def add_user_scores(user, score_data)
    # Atualizar ou criar RoundScore
    round_score = user.round_scores.find_or_initialize_by(round: @round)
    round_score.total_points ||= 0
    round_score.exact_scores ||= 0
    round_score.correct_results ||= 0
    
    round_score.total_points += score_data[:points]
    round_score.exact_scores += 1 if score_data[:exact_score]
    round_score.correct_results += 1 if score_data[:correct_result]
    
    if score_data[:match]&.involves_favorite?
      round_score.special_exact_scores ||= 0
      round_score.special_correct_results ||= 0
      round_score.special_exact_scores += 1 if score_data[:exact_score]
      round_score.special_correct_results += 1 if score_data[:correct_result]
    end
    
    round_score.save!
    
    # Atualizar OverallStanding
    overall = OverallStanding.find_or_initialize_by(user: user, championship_id: @championship.id)
    overall.total_points ||= 0
    overall.total_points += score_data[:points]
    overall.save!
  end
  
  def update_user_scores(user, score_data)
    add_user_scores(user, score_data.merge(match: @match))
  end
  
  def recalculate_round_positions
    scores = @round.round_scores.order(total_points: :desc, exact_scores: :desc, created_at: :asc)
    scores.each_with_index do |score, index|
      score.update_column(:position, index + 1)
    end
  end
  
  def recalculate_overall_positions
    standings = @championship.overall_standings.order(total_points: :desc, rounds_won: :desc)
    standings.each_with_index do |standing, index|
      standing.update_column(:position, index + 1)
    end
  end
end
