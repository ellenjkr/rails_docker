#!/bin/bash
set -e

# Espera o PostgreSQL iniciar
until pg_isready -h db -p 5432 -U postgres; do
  echo "Aguardando Postgres..."
  sleep 1
done

# Cria a pasta www se não existir
mkdir -p /app/www
chown -R $(whoami):$(whoami) /app/www

# Cria novo projeto Rails se estiver vazio
if [ -z "$(ls -A /app/www)" ]; then
  echo "Pasta www vazia. Criando novo projeto Rails..."
  rails new /app/www --database=postgresql --skip-javascript
fi

# Roda bundle install e migrações dentro do www
cd /app/www
bundle install
bundle exec rails db:create db:migrate 2>/dev/null || true

# Finalmente, roda o servidor Rails
exec bundle exec rails server -b 0.0.0.0 -p 3000
