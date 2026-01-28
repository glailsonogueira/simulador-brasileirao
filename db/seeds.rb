# encoding: utf-8
puts "Limpando banco de dados..."
[Prediction, RoundScore, OverallStanding, Match, Round, ChampionshipClub, Championship, Club, User].each(&:destroy_all)
puts "✓ Banco limpo"

User.create!(
  name: 'Administrador',
  email: 'admin@brasileirao.com',
  password: 'senha123',
  password_confirmation: 'senha123',
  admin: true,
  active: true
)
puts "✓ Usuário admin criado"

clubs_data = [
  { name: 'Athletico Paranaense', abbreviation: 'CAP', primary_color: '#FF0000', special_club: false, badge_filename: 'athletico-paranaense.png' },
  { name: 'Atlético Mineiro', abbreviation: 'CAM', primary_color: '#000000', special_club: false, badge_filename: 'atletico-mineiro.png' },
  { name: 'Bahia', abbreviation: 'BAH', primary_color: '#0000FF', special_club: false, badge_filename: 'bahia.png' },
  { name: 'Botafogo', abbreviation: 'BOT', primary_color: '#000000', special_club: false, badge_filename: 'botafogo.png' },
  { name: 'Chapecoense', abbreviation: 'CHA', primary_color: '#008000', special_club: false, badge_filename: 'chapecoense.png' },
  { name: 'Corinthians', abbreviation: 'COR', primary_color: '#000000', special_club: false, badge_filename: 'corinthians.png' },
  { name: 'Coritiba', abbreviation: 'CFC', primary_color: '#00FF00', special_club: false, badge_filename: 'coritiba.png' },
  { name: 'Cruzeiro', abbreviation: 'CRU', primary_color: '#0000FF', special_club: false, badge_filename: 'cruzeiro.png' },
  { name: 'Flamengo', abbreviation: 'FLA', primary_color: '#FF0000', special_club: false, badge_filename: 'flamengo.png' },
  { name: 'Fluminense', abbreviation: 'FLU', primary_color: '#8B0000', special_club: false, badge_filename: 'fluminense.png' },
  { name: 'Grêmio', abbreviation: 'GRE', primary_color: '#0000FF', special_club: false, badge_filename: 'gremio.png' },
  { name: 'Internacional', abbreviation: 'INT', primary_color: '#FF0000', special_club: false, badge_filename: 'internacional.png' },
  { name: 'Mirassol', abbreviation: 'MIR', primary_color: '#FFFF00', special_club: false, badge_filename: 'mirassol.png' },
  { name: 'Palmeiras', abbreviation: 'PAL', primary_color: '#008000', special_club: false, badge_filename: 'palmeiras.png' },
  { name: 'Red Bull Bragantino', abbreviation: 'RBB', primary_color: '#FFFFFF', special_club: false, badge_filename: 'red-bull-bragantino.png' },
  { name: 'Remo', abbreviation: 'REM', primary_color: '#0000FF', special_club: true, badge_filename: 'remo.png' },
  { name: 'Santos', abbreviation: 'SAN', primary_color: '#FFFFFF', special_club: false, badge_filename: 'santos.png' },
  { name: 'São Paulo', abbreviation: 'SAO', primary_color: '#FF0000', special_club: false, badge_filename: 'sao-paulo.png' },
  { name: 'Vasco da Gama', abbreviation: 'VAS', primary_color: '#000000', special_club: false, badge_filename: 'vasco-da-gama.png' },
  { name: 'Vitória', abbreviation: 'VIT', primary_color: '#FF0000', special_club: false, badge_filename: 'vitoria.png' }
]

clubs_data.each { |c| Club.create!(c) }
puts "✓ #{Club.count} clubes criados"

championship_2026 = Championship.create!(
  year: 2026,
  name: 'Brasileirão Série A',
  active: false,
  start_date: Date.new(2026, 4, 10),
  end_date: Date.new(2026, 12, 5)
)

clubs_serie_a = [
  'Athletico Paranaense', 'Atlético Mineiro', 'Bahia', 'Botafogo',
  'Chapecoense', 'Corinthians', 'Coritiba', 'Cruzeiro',
  'Flamengo', 'Fluminense', 'Grêmio', 'Internacional',
  'Mirassol', 'Palmeiras', 'Red Bull Bragantino', 'Remo',
  'Santos', 'São Paulo', 'Vasco da Gama', 'Vitória'
]

clubs_serie_a.each_with_index do |name, i|
  championship_2026.championship_clubs.create!(
    club: Club.find_by(name: name),
    position_order: i + 1
  )
end
puts "✓ 20 clubes adicionados"

championship_2026.update!(active: true)
38.times { |i| championship_2026.rounds.create!(number: i + 1) }
puts "✓ 38 rodadas criadas"

round1 = championship_2026.rounds.first
clubs = championship_2026.clubs.where.not(name: 'Remo').to_a.shuffle
remo = championship_2026.clubs.find_by(name: 'Remo')

Match.create!(round: round1, home_club: remo, away_club: clubs.pop, scheduled_at: DateTime.new(2026, 4, 10, 19, 0))
9.times { |i| Match.create!(round: round1, home_club: clubs.pop, away_club: clubs.pop, scheduled_at: DateTime.new(2026, 4, 10 + i/3, 19 + i%3, 0)) }

puts "✓ 10 partidas criadas"
puts ""
puts "Setup completo! http://localhost:3000"
puts "Admin: admin@brasileirao.com / senha123"
