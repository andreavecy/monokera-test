# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM ruby:${RUBY_VERSION}-slim AS base

# Set working directory
WORKDIR /rails

# Instalación de dependencias del sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libvips \
    libjemalloc2 \
    curl \
    postgresql-client \
    git \
    nodejs \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Variables de entorno
ENV RAILS_ENV=development \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLER_VERSION=2.5.17

# Instalar la versión específica de Bundler (opcional pero recomendado)
RUN gem install bundler -v $BUNDLER_VERSION

# Copiar archivos del bundler
COPY Gemfile Gemfile.lock ./

# Instalar gemas
RUN bundle install

# Copiar el resto de la app
COPY . .

# Precompilar bootsnap para acelerar el arranque
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Crear usuario rails (mejora de seguridad)
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails

# Puerto de salida
EXPOSE 3000

# Script de entrada (verifica que existe /bin/docker-entrypoint)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Comando por defecto
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
