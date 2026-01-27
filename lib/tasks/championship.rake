# lib/tasks/championship.rake
namespace :championship do
  desc "Criar novo campeonato"
  task :create, [:year] => :environment do |t, args|
    year = args[:year].to_i
    
    championship = Championship.create!(
      year: year,
      name: "Brasileirão Série A",
      active: false
    )
    
    puts "✓ Campeonato #{year} criado (ID: #{championship.id})"
    puts "Próximo passo: Adicionar 20 clubes via Admin"
  end
  
  desc "Ativar campeonato específico"
  task :activate, [:year] => :environment do |t, args|
    year = args[:year].to_i
    
    Championship.update_all(active: false)
    championship = Championship.find_by(year: year)
    
    if championship
      championship.update(active: true)
      puts "✓ Campeonato #{year} ativado"
    else
      puts "✗ Campeonato #{year} não encontrado"
    end
  end
  
  desc "Listar todos os campeonatos"
  task list: :environment do
    championships = Championship.order(year: :desc)
    
    puts "\n📋 Campeonatos cadastrados:"
    puts "=" * 60
    
    championships.each do |c|
      status = c.active? ? "ATIVO ✓" : "Inativo"
      clubs = "#{c.clubs_count}/20 clubes"
      rounds = "#{c.rounds.count}/38 rodadas"
      
      puts "#{c.year} - #{c.name}"
      puts "  Status: #{status}"
      puts "  #{clubs} | #{rounds}"
      puts "-" * 60
    end
  end
  
  desc "Adicionar clube a campeonato"
  task :add_club, [:year, :club_name] => :environment do |t, args|
    championship = Championship.find_by(year: args[:year].to_i)
    club = Club.find_by(name: args[:club_name])
    
    unless championship
      puts "✗ Campeonato #{args[:year]} não encontrado"
      next
    end
    
    unless club
      puts "✗ Clube '#{args[:club_name]}' não encontrado"
      next
    end
    
    if championship.can_add_club?
      championship.clubs << club
      puts "✓ #{club.name} adicionado ao campeonato #{championship.year}"
      puts "  Total: #{championship.clubs_count}/20 clubes"
    else
      puts "✗ Campeonato já possui 20 clubes"
    end
  rescue ActiveRecord::RecordInvalid => e
    puts "✗ Erro: #{e.message}"
  end
  
  desc "Gerar rodadas para campeonato"
  task :generate_rounds, [:year] => :environment do |t, args|
    championship = Championship.find_by(year: args[:year].to_i)
    
    unless championship
      puts "✗ Campeonato #{args[:year]} não encontrado"
      next
    end
    
    unless championship.complete?
      puts "✗ Campeonato precisa de 20 clubes (atual: #{championship.clubs_count})"
      next
    end
    
    if championship.rounds.any?
      puts "✗ Rodadas já foram geradas"
      next
    end
    
    38.times do |i|
      championship.rounds.create!(number: i + 1)
    end
    
    puts "✓ 38 rodadas criadas para o campeonato #{championship.year}"
  end
  
  desc "Importar times da Série A de um ano"
  task :import_serie_a, [:year, :teams_list] => :environment do |t, args|
    championship = Championship.find_by(year: args[:year].to_i)
    
    unless championship
      puts "✗ Campeonato #{args[:year]} não encontrado"
      next
    end
    
    # Lista de times separada por vírgula
    team_names = args[:teams_list].split(',').map(&:strip)
    
    if team_names.count != 20
      puts "✗ É necessário exatamente 20 times (fornecido: #{team_names.count})"
      next
    end
    
    added = 0
    team_names.each do |name|
      club = Club.find_by(name: name)
      if club
        begin
          championship.clubs << club
          added += 1
          puts "✓ #{club.name}"
        rescue ActiveRecord::RecordInvalid
          puts "⚠ #{name} já está no campeonato"
        end
      else
        puts "✗ Clube '#{name}' não encontrado no sistema"
      end
    end
    
    puts "\n✓ #{added} clubes adicionados ao campeonato #{championship.year}"
  end
  
  desc "Remover todos os clubes de um campeonato"
  task :clear_clubs, [:year] => :environment do |t, args|
    championship = Championship.find_by(year: args[:year].to_i)
    
    unless championship
      puts "✗ Campeonato #{args[:year]} não encontrado"
      next
    end
    
    count = championship.clubs.count
    championship.clubs.clear
    
    puts "✓ #{count} clubes removidos do campeonato #{championship.year}"
  end
end
