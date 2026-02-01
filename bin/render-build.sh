#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# Rodar seeds apenas se a variável RUN_SEEDS=true
if [ "$RUN_SEEDS" = "true" ]; then
  echo "==> RUN_SEEDS is true, running seeds..."
  bundle exec rails db:seed
else
  echo "==> RUN_SEEDS is not set or false, skipping seeds..."
fi
