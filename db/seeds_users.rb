# Criar usuários
users_data = [
  { name: 'Kynho Aviz', email: 'vynnyaviz@gmail.com', nickname: 'Kynho', admin: false },
  { name: 'Felipe Virgolino Batista', email: 'felipevirgolinobatista@gmail.com', nickname: 'Felipe', admin: true },
  { name: 'Lucas Fonseca', email: 'lucascauafonseca@gmail.com', nickname: 'Lucas', admin: false },
  { name: 'Sirnande de Lima', email: 'sirnandelima95@gmail.com', nickname: 'Sid', admin: false },
  { name: 'Selton Santiago', email: 'seltonsantiago@gmail.com', nickname: 'Selton', admin: false },
  { name: 'Leandro Monteiro', email: 'leandroconsultor.no@gmail.com', nickname: 'Leandro', admin: false },
  { name: 'Glailson Nogueira', email: 'glailsonogueira@gmail.com', nickname: 'Glailson', admin: true }
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
