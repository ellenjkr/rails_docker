# syntax=docker/dockerfile:1

FROM ruby:3.2

# Instala dependências do sistema
RUN apt-get update -qq && \
    apt-get install -y postgresql-client libpq-dev build-essential curl && \
    rm -rf /var/lib/apt/lists/*

# Diretório da aplicação
WORKDIR /app

# Cria usuário com home
RUN useradd -m appuser
USER appuser

# Instala bundler e Rails
RUN gem install bundler -v 2.4.13
RUN gem install rails

# Expõe porta Rails
EXPOSE 3000

# Entry point
ENTRYPOINT ["./entrypoint.sh"]
