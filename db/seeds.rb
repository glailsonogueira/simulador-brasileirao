# encoding: utf-8
require 'roo'

puts "Limpando banco de dados..."
[Prediction, RoundScore, OverallStanding, Match, Round, Championship, ChampionshipClub, ClubStadium, Club, Stadium, User].each(&:destroy_all)
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

# Criar estádios
stadiums_data = [
  { name: 'Arena da Baixada', city: 'Curitiba', state: 'PR' },
  { name: 'Arena MRV', city: 'Belo Horizonte', state: 'MG' },
  { name: 'Arena Fonte Nova', city: 'Salvador', state: 'BA' },
  { name: 'Estádio Nilton Santos', city: 'Rio de Janeiro', state: 'RJ' },
  { name: 'Arena Condá', city: 'Chapecó', state: 'SC' },
  { name: 'Neo Química Arena', city: 'São Paulo', state: 'SP' },
  { name: 'Couto Pereira', city: 'Curitiba', state: 'PR' },
  { name: 'Mineirão', city: 'Belo Horizonte', state: 'MG' },
  { name: 'Maracanã', city: 'Rio de Janeiro', state: 'RJ' },
  { name: 'Arena do Grêmio', city: 'Porto Alegre', state: 'RS' },
  { name: 'Beira-Rio', city: 'Porto Alegre', state: 'RS' },
  { name: 'Estádio José Maria de Campos Maia', city: 'Mirassol', state: 'SP' },
  { name: 'Allianz Parque', city: 'São Paulo', state: 'SP' },
  { name: 'Nabi Abi Chedid', city: 'Bragança Paulista', state: 'SP' },
  { name: 'Mangueirão', city: 'Belém', state: 'PA' },
  { name: 'Baenão', city: 'Belém', state: 'PA' },
  { name: 'Vila Belmiro', city: 'Santos', state: 'SP' },
  { name: 'Morumbi', city: 'São Paulo', state: 'SP' },
  { name: 'São Januário', city: 'Rio de Janeiro', state: 'RJ' },
  { name: 'Barradão', city: 'Salvador', state: 'BA' }
]

stadiums_data.each { |s| Stadium.create!(s) }
puts "✓ #{Stadium.count} estádios criados"

clubs_data = [
  { name: 'Athletico Paranaense', abbreviation: 'CAP', primary_color: '#FF0000', special_club: false, badge_filename: 'athletico-paranaense.png', primary_stadium: 'Arena da Baixada' },
  { name: 'Atlético Mineiro', abbreviation: 'CAM', primary_color: '#000000', special_club: false, badge_filename: 'atletico-mineiro.png', primary_stadium: 'Arena MRV' },
  { name: 'Bahia', abbreviation: 'BAH', primary_color: '#0000FF', special_club: false, badge_filename: 'bahia.png', primary_stadium: 'Arena Fonte Nova' },
  { name: 'Botafogo', abbreviation: 'BOT', primary_color: '#000000', special_club: false, badge_filename: 'botafogo.png', primary_stadium: 'Estádio Nilton Santos' },
  { name: 'Chapecoense', abbreviation: 'CHA', primary_color: '#008000', special_club: false, badge_filename: 'chapecoense.png', primary_stadium: 'Arena Condá' },
  { name: 'Corinthians', abbreviation: 'COR', primary_color: '#000000', special_club: false, badge_filename: 'corinthians.png', primary_stadium: 'Neo Química Arena' },
  { name: 'Coritiba', abbreviation: 'CFC', primary_color: '#165f11', special_club: false, badge_filename: 'coritiba.png', primary_stadium: 'Couto Pereira' },
  { name: 'Cruzeiro', abbreviation: 'CRU', primary_color: '#2B519F', special_club: false, badge_filename: 'cruzeiro.png', primary_stadium: 'Mineirão' },
  { name: 'Flamengo', abbreviation: 'FLA', primary_color: '#FF0000', special_club: false, badge_filename: 'flamengo.png', primary_stadium: 'Maracanã' },
  { name: 'Fluminense', abbreviation: 'FLU', primary_color: '#8B0000', special_club: false, badge_filename: 'fluminense.png', primary_stadium: 'Maracanã' },
  { name: 'Grêmio', abbreviation: 'GRE', primary_color: '#0581C0', special_club: false, badge_filename: 'gremio.png', primary_stadium: 'Arena do Grêmio' },
  { name: 'Internacional', abbreviation: 'INT', primary_color: '#FF0000', special_club: false, badge_filename: 'internacional.png', primary_stadium: 'Beira-Rio' },
  { name: 'Mirassol', abbreviation: 'MIR', primary_color: '#F6EA10', special_club: false, badge_filename: 'mirassol.png', primary_stadium: 'Estádio José Maria de Campos Maia' },
  { name: 'Palmeiras', abbreviation: 'PAL', primary_color: '#008000', special_club: false, badge_filename: 'palmeiras.png', primary_stadium: 'Allianz Parque' },
  { name: 'Red Bull Bragantino', abbreviation: 'RBB', primary_color: '#FDCD02', special_club: false, badge_filename: 'red-bull-bragantino.png', primary_stadium: 'Nabi Abi Chedid' },
  { name: 'Remo', abbreviation: 'REM', primary_color: '#1D1D7C', special_club: true, badge_filename: 'remo.png', primary_stadium: 'Mangueirão' },
  { name: 'Santos', abbreviation: 'SAN', primary_color: '#FFFFFF', special_club: false, badge_filename: 'santos.png', primary_stadium: 'Vila Belmiro' },
  { name: 'São Paulo', abbreviation: 'SAO', primary_color: '#FF0000', special_club: false, badge_filename: 'sao-paulo.png', primary_stadium: 'Morumbi' },
  { name: 'Vasco da Gama', abbreviation: 'VAS', primary_color: '#000000', special_club: false, badge_filename: 'vasco-da-gama.png', primary_stadium: 'São Januário' },
  { name: 'Vitória', abbreviation: 'VIT', primary_color: '#FF0000', special_club: false, badge_filename: 'vitoria.png', primary_stadium: 'Barradão' }
]

clubs_data.each do |c|
  stadium = Stadium.find_by(name: c.delete(:primary_stadium))
  Club.create!(c.merge(primary_stadium: stadium))
end
puts "✓ #{Club.count} clubes criados com estádios"

# Adicionar Baenão como estádio secundário do Remo
remo = Club.find_by(name: 'Remo')
baenao = Stadium.find_by(name: 'Baenão')
remo.club_stadiums.create!(stadium: baenao)
puts "✓ Baenão adicionado como estádio secundário do Remo"

championship_2026 = Championship.create!(
  year: 2026,
  name: 'Brasileirão Série A',
  active: false,
  start_date: Date.new(2026, 1, 28),
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

# Definir Remo como clube favorito
championship_2026.update!(favorite_club: remo)
puts "✓ Remo definido como clube favorito"

championship_2026.update!(active: true)
38.times { |i| championship_2026.rounds.create!(number: i + 1) }
puts "✓ 38 rodadas criadas"

# Ler planilha e criar partidas das 8 primeiras rodadas
xlsx = Roo::Spreadsheet.open(Rails.root.join('storage', 'rodadas_brasileirao.xlsx'))
sheet = xlsx.sheet(0)

# Mapeamento de nomes de clubes (planilha -> banco)
club_mapping = {
  'Athletico' => 'Athletico Paranaense',
  'Atlético Mineiro' => 'Atlético Mineiro',
  'Bahia' => 'Bahia',
  'Botafogo' => 'Botafogo',
  'Chapecoense' => 'Chapecoense',
  'Corinthians' => 'Corinthians',
  'Coritiba' => 'Coritiba',
  'Cruzeiro' => 'Cruzeiro',
  'Flamengo' => 'Flamengo',
  'Fluminense' => 'Fluminense',
  'Grêmio' => 'Grêmio',
  'Internacional' => 'Internacional',
  'Mirassol' => 'Mirassol',
  'Palmeiras' => 'Palmeiras',
  'Red Bull Bragantino' => 'Red Bull Bragantino',
  'Remo' => 'Remo',
  'Santos' => 'Santos',
  'São Paulo' => 'São Paulo',
  'Vasco' => 'Vasco da Gama',
  'Vitória' => 'Vitória'
}

matches_created = 0
(2..sheet.last_row).each do |i|
  row = sheet.row(i)
  round_number = row[0].to_i
  
  break if round_number > 8 # Só criar até rodada 8
  
  date = row[1]
  time_seconds = row[2].to_i
  home_name = club_mapping[row[3]] || row[3]
  away_name = club_mapping[row[4]] || row[4]
  stadium_name = row[5]
  
  round = championship_2026.rounds.find_by(number: round_number)
  home_club = Club.find_by(name: home_name)
  away_club = Club.find_by(name: away_name)
  stadium = Stadium.find_by(name: stadium_name)
  
  if home_club && away_club && round
    hours = time_seconds / 3600
    minutes = (time_seconds % 3600) / 60
    
    # IMPORTANTE: Usar Time.zone.local para respeitar o fuso horário de Brasília (UTC-3)
    scheduled_at = Time.zone.local(date.year, date.month, date.day, hours, minutes, 0)
    
    Match.create!(
      round: round,
      home_club: home_club,
      away_club: away_club,
      stadium: stadium,
      scheduled_at: scheduled_at
    )
    matches_created += 1
  end
end

puts "✓ #{matches_created} partidas das 8 primeiras rodadas criadas"
puts ""
puts "Setup completo! http://localhost:3000"
puts "Admin: admin@brasileirao.com / senha123"

# ====================
# IMPORTAR USUÁRIOS
# ====================
puts ""
puts "Importando usuários..."

users_data = [
  { name: 'Kynho Aviz', email: 'vynnyaviz@gmail.com', admin: false },
  { name: 'Felipe Virgolino', email: 'felipevirgolinobatista@gmail.com', admin: true },
  { name: 'Lucas Fonseca', email: 'lucascauafonseca@gmail.com', admin: false },
  { name: 'Sirnande de Lima', email: 'sirnandelima95@gmail.com', admin: false },
  { name: 'Selton Santiago', email: 'seltonsantiago@gmail.com', admin: false },
  { name: 'Leandro Monteiro', email: 'leandroconsultor.no@gmail.com', admin: false },
  { name: 'Glailson Nogueira', email: 'glailsonogueira@gmail.com', admin: true }
]

users_data.each do |user_data|
  User.create!(
    name: user_data[:name],
    email: user_data[:email],
    password: 'felipefresco',
    password_confirmation: 'felipefresco',
    admin: user_data[:admin],
    active: true
  )
end

puts "✓ #{User.count} usuários criados"

# ====================
# IMPORTAR PREVISÕES
# ====================
puts ""
puts "Importando previsões da Rodada 1..."

require 'roo'

xlsx = Roo::Spreadsheet.open(Rails.root.join('storage', 'cadastro_previsoes_usuario.xlsx'))
sheet = xlsx.sheet(0)

club_mapping = {
  'Athletico Paranaense' => 'Athletico Paranaense',
  'Athletico' => 'Athletico Paranaense',
  'Atlético Mineiro' => 'Atlético Mineiro',
  'Bahia' => 'Bahia',
  'Botafogo' => 'Botafogo',
  'Chapecoense' => 'Chapecoense',
  'Corinthians' => 'Corinthians',
  'Coritiba' => 'Coritiba',
  'Cruzeiro' => 'Cruzeiro',
  'Flamengo' => 'Flamengo',
  'Fluminense' => 'Fluminense',
  'Grêmio' => 'Grêmio',
  'Internacional' => 'Internacional',
  'Mirassol' => 'Mirassol',
  'Palmeiras' => 'Palmeiras',
  'Red Bull Bragantino' => 'Red Bull Bragantino',
  'Remo' => 'Remo',
  'Santos' => 'Santos',
  'São Paulo' => 'São Paulo',
  'Vasco da Gama' => 'Vasco da Gama',
  'Vitória' => 'Vitória'
}

championship = Championship.find_by(active: true)
round1 = championship.rounds.find_by(number: 1)

created_count = 0
skipped_count = 0

(2..sheet.last_row).each do |i|
  row = sheet.row(i)
  
  email = row[0]
  home_name = club_mapping[row[1]] || row[1]
  placar_casa = row[2]
  placar_fora = row[3]
  away_name = club_mapping[row[4]] || row[4]
  predicted_at = row[5]
  
  next if placar_casa.nil? || placar_fora.nil?
  
  user = User.find_by(email: email)
  next unless user
  
  home_club = Club.find_by(name: home_name)
  away_club = Club.find_by(name: away_name)
  next unless home_club && away_club
  
  match = round1.matches.find_by(home_club: home_club, away_club: away_club)
  next unless match
  
  prediction = Prediction.find_or_initialize_by(user: user, match: match)
  prediction.home_score = placar_casa.to_i
  prediction.away_score = placar_fora.to_i
  prediction.predicted_at = predicted_at.present? ? predicted_at : Time.current
  
  if prediction.save
    created_count += 1
  else
    skipped_count += 1
  end
end

puts "✓ #{created_count} previsões importadas"
puts "✗ #{skipped_count} previsões ignoradas" if skipped_count > 0

puts ""
puts "=" * 50
puts "Setup completo com usuários e previsões!"
puts "Admin: admin@brasileirao.com / senha123"
puts "Outros usuários: senha 'felipefresco'"
puts "=" * 50
