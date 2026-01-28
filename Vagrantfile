# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Box Ubuntu 22.04 LTS
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "simulador-brasileirao"
  
  # Configuração de rede
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "private_network", ip: "192.168.56.10"
  
  # Sincronizar pasta do projeto
  config.vm.synced_folder ".", "/home/vagrant/simulador-brasileirao"
  
  # Configuração de recursos
  config.vm.provider "virtualbox" do |vb|
    vb.name = "simulador-brasileirao"
    vb.memory = "2048"
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  
  # Provisionar VM com script
  config.vm.provision "shell", inline: <<-SHELL
    echo "=========================================="
    echo "🚀 Instalando Brasileirão Simulator"
    echo "=========================================="
    
    # Atualizar sistema
    echo "📦 Atualizando sistema..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get upgrade -y -qq
    
    # Instalar dependências básicas
    echo "📦 Instalando dependências básicas..."
    apt-get install -y -qq \
      build-essential \
      git \
      curl \
      wget \
      vim \
      libssl-dev \
      libreadline-dev \
      zlib1g-dev \
      autoconf \
      bison \
      libyaml-dev \
      libncurses5-dev \
      libffi-dev \
      libgdbm-dev \
      libjemalloc2 \
      libvips \
      sqlite3 \
      libsqlite3-dev
    
    # Instalar PostgreSQL
    echo "🐘 Instalando PostgreSQL..."
    apt-get install -y -qq postgresql postgresql-contrib libpq-dev
    
    # Configurar PostgreSQL
    sudo -u postgres psql -c "CREATE USER vagrant WITH SUPERUSER PASSWORD 'vagrant';" 2>/dev/null || true
    sudo -u postgres psql -c "ALTER USER vagrant CREATEDB;" 2>/dev/null || true
    
    # Configurar autenticação PostgreSQL
    echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/14/main/pg_hba.conf
    echo "listen_addresses = '*'" >> /etc/postgresql/14/main/postgresql.conf
    systemctl restart postgresql
    
    # Instalar Node.js 20 (versão LTS atual)
    echo "📦 Instalando Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y -qq nodejs
    
    # Instalar Yarn
    echo "📦 Instalando Yarn..."
    npm install -g yarn
    
    # Instalar rbenv para usuário vagrant
    echo "💎 Instalando Ruby via rbenv..."
    sudo -u vagrant bash << 'EOF'
      # Instalar rbenv
      if [ ! -d ~/.rbenv ]; then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
      fi
      
      # Instalar ruby-build
      if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
        git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
      fi
      
      # Carregar rbenv
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init - bash)"
      
      # Instalar Ruby 3.2.0
      if ! rbenv versions | grep -q "3.2.0"; then
        echo "⏳ Instalando Ruby 3.2.0 (pode demorar 5-10 minutos)..."
        rbenv install 3.2.0
      fi
      rbenv global 3.2.0
      
      # Instalar Bundler
      gem install bundler
      rbenv rehash
      
      echo "✓ Ruby $(ruby -v) instalado"
EOF
    
    # Criar arquivo .env
    echo "🏗️  Configurando projeto..."
    sudo -u vagrant bash << 'EOF'
      if [ ! -f /home/vagrant/simulador-brasileirao/.env ]; then
        cat > /home/vagrant/simulador-brasileirao/.env << 'ENVFILE'
DATABASE_USERNAME=vagrant
DATABASE_PASSWORD=vagrant
DATABASE_HOST=localhost

GOOGLE_CLIENT_ID=seu_client_id_aqui
GOOGLE_CLIENT_SECRET=seu_client_secret_aqui

RAILS_ENV=development
RAILS_MAX_THREADS=5
ENVFILE
        echo "✓ Arquivo .env criado"
      fi
EOF
    
    # Instalar gems, criar banco e popular - TUDO EM UM ÚNICO BLOCO
    echo "💎 Instalando gems e configurando banco de dados..."
    sudo -u vagrant bash << 'EOF'
      # Carregar rbenv
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init - bash)"
      
      # Ir para o diretório do projeto
      cd /home/vagrant/simulador-brasileirao
      
      # Verificar se está no diretório correto
      if [ ! -f "Gemfile" ]; then
        echo "❌ ERRO: Gemfile não encontrado!"
        exit 1
      fi
      
      echo "📍 Diretório atual: $(pwd)"
      
      # Instalar gems
      echo "📦 Instalando gems..."
      bundle install
      
      # Criar bancos
      echo "🗄️  Criando bancos de dados..."
      bundle exec rails db:create
      
      # Rodar migrations
      echo "📊 Rodando migrations..."
      bundle exec rails db:migrate
      
      # Rodar seeds
      echo "🌱 Populando banco de dados..."
      bundle exec rails db:seed
      
      echo "✅ Configuração do projeto concluída!"
EOF
    
    # Criar script de inicialização
    cat > /usr/local/bin/start-brasileirao << 'STARTSCRIPT'
#!/bin/bash
cd /home/vagrant/simulador-brasileirao
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
bundle exec rails server -b 0.0.0.0
STARTSCRIPT
    
    chmod +x /usr/local/bin/start-brasileirao
    chown vagrant:vagrant /usr/local/bin/start-brasileirao
    
    # Criar serviço systemd
    cat > /etc/systemd/system/brasileirao.service << 'SERVICE'
[Unit]
Description=Brasileirao Simulator Rails Server
After=network.target postgresql.service

[Service]
Type=simple
User=vagrant
WorkingDirectory=/home/vagrant/simulador-brasileirao
Environment="PATH=/home/vagrant/.rbenv/shims:/home/vagrant/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStart=/home/vagrant/.rbenv/shims/bundle exec rails server -b 0.0.0.0
Restart=on-failure

[Install]
WantedBy=multi-user.target
SERVICE
    
    # Recarregar systemd
    systemctl daemon-reload
    
    echo ""
    echo "=========================================="
    echo "✅ Instalação Completa!"
    echo "=========================================="
    echo ""
    echo "🌐 Acesse: http://localhost:3000"
    echo "   ou: http://192.168.56.10:3000"
    echo ""
    echo "👤 Login Admin:"
    echo "   Email: admin@brasileirao.com"
    echo "   Senha: senha123"
    echo ""
    echo "📋 Comandos úteis:"
    echo "   vagrant ssh                  # Conectar na VM"
    echo "   start-brasileirao            # Iniciar servidor"
    echo "   cd ~/simulador-brasileirao   # Ir para projeto"
    echo ""
    echo "🔧 Serviço systemd:"
    echo "   sudo systemctl start brasileirao    # Iniciar"
    echo "   sudo systemctl stop brasileirao     # Parar"
    echo "   sudo systemctl enable brasileirao   # Auto-start"
    echo ""
    echo "=========================================="
  SHELL
  
  # Iniciar servidor automaticamente
  config.vm.provision "shell", run: "always", inline: <<-SHELL
    echo "🚀 Iniciando servidor Rails..."
    sudo -u vagrant bash << 'EOF'
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init - bash)"
      cd /home/vagrant/simulador-brasileirao
      bundle exec rails server -b 0.0.0.0 -d
EOF
    echo "✓ Servidor iniciado em http://localhost:3000"
  SHELL
end
