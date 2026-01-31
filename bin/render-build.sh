#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# Rodar seeds se ainda não tem usuários
if bundle exec rails runner "exit(User.count == 0 ? 0 : 1)"; then
  echo "==> Running seeds..."
  bundle exec rails db:seed
else
  echo "==> Seeds already ran, skipping..."
fi
