# ⚽ Simulações do Brasileirão by Renegados Azulinos

Sistema de simulação e previsões para o Campeonato Brasileiro de Futebol.

![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-7.2.3-red?logo=rubyonrails)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql)
![License](https://img.shields.io/badge/license-MIT-green)

##  Sobre o Projeto

Sistema completo de previsões e rankings para o Brasileirão, onde usuários podem:
- Fazer previsões dos placares das partidas
- Competir em rankings gerais e por rodada
- Acompanhar pontuações com sistema especial para jogos do Remo ⭐

## ✨ Funcionalidades

###  Para Usuários
- **Autenticação:** Login via email/senha ou Google OAuth
- **Previsões:** Sistema de palpites com bloqueio automático de rodadas
- **Rankings:** 
  - Classificação geral do campeonato
  - Rankings individuais por rodada
  - Histórico detalhado de desempenho
- **Pontuação:**
  - Placar exato: 10 pontos (20 para jogos do Remo ⭐)
  - Resultado correto: 5 pontos (10 para jogos do Remo ⭐)

###  Para Administradores
- Gestão completa de campeonatos
- Cadastro e gerenciamento de clubes
- Criação e edição de partidas
- Registro de resultados
- Gerenciamento de usuários e permissões

##  Tecnologias

- **Backend:** Ruby on Rails 7.2.3
- **Banco de Dados:** PostgreSQL
- **Autenticação:** Devise + OmniAuth (Google)
- **Frontend:** ERB, HTML5, CSS3
- **Versionamento:** Git/GitHub

##  Instalação

### Pré-requisitos

- Ruby 3.2.0
- PostgreSQL 16
- Git

### Passo a Passo

1. **Clone o repositório:**
```bash
git clone https://github.com/glailsonogueira/simulador-brasileirao.git
cd simulador-brasileirao
```

2. **Instale as dependências:**
```bash
bundle install
```

3. **Configure o banco de dados:**
```bash
# Edite config/database.yml com suas credenciais
cp config/database.yml.example config/database.yml

# Crie e configure o banco
rails db:create
rails db:migrate
rails db:seed
```

4. **Inicie o servidor:**
```bash
rails server
```

5. **Acesse:** http://localhost:3000

### Credenciais Padrão

Após rodar `rails db:seed`:
- **Email:** admin@brasileirao.com
- **Senha:** senha123

## ️ Estrutura do Projeto
```
app/
├── controllers/          # Controladores da aplicação
│   ├── admin/           # Área administrativa
│   ├── home_controller.rb
│   ├── predictions_controller.rb
│   └── rankings_controller.rb
├── models/              # Modelos de dados
│   ├── championship.rb
│   ├── club.rb
│   ├── match.rb
│   ├── prediction.rb
│   └── user.rb
├── views/               # Views (ERB)
│   ├── admin/
│   ├── home/
│   ├── predictions/
│   └── rankings/
└── services/            # Lógica de negócio
    └── score_calculator_service.rb

db/
├── migrate/             # Migrations do banco
└── seeds.rb            # Dados iniciais
```

##  Modelos de Dados

### Principais Entidades

- **User:** Usuários do sistema
- **Championship:** Campeonatos (ex: Brasileirão 2026)
- **Club:** Clubes participantes
- **Round:** Rodadas do campeonato
- **Match:** Partidas
- **Prediction:** Previsões dos usuários
- **RoundScore:** Pontuação por rodada
- **OverallStanding:** Classificação geral

##  Regras de Negócio

### Sistema de Bloqueio de Rodadas
- Rodada 1 sempre liberada
- Rodadas seguintes bloqueadas até que todos os jogos da rodada anterior sejam finalizados
- Previsões bloqueadas 1 hora antes do primeiro jogo da rodada

### Pontuação Especial Remo ⭐
- Jogos do Remo têm pontuação DOBRADA
- Incentiva engajamento da torcida azulina

### Cálculo de Rankings
- Rankings atualizados automaticamente após cada resultado
- Critérios de desempate: pontos totais > rodadas vencidas

##  Segurança

- Senhas criptografadas com bcrypt
- Proteção CSRF
- Validações em models e controllers
- Área administrativa protegida por permissões

##  Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

##  Roadmap

- [ ] Sistema de notificações por email
- [ ] API REST para aplicativos mobile
- [ ] Sistema de apostas virtuais
- [ ] Integração com dados ao vivo
- [ ] Dashboard com gráficos e estatísticas avançadas
- [ ] Sistema de badges e conquistas

## ‍ Autor

**Glailson Ogueira**
- GitHub: [@glailsonogueira](https://github.com/glailsonogueira)

##  Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

⚽ Feito com ❤️ pelos Renegados Azulinos
