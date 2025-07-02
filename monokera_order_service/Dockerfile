# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

# Dependencias del sistema
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
    libffi-dev \
    libyaml-dev \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Variables de entorno
ENV RAILS_ENV=development \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/bundle" \
    BUNDLER_VERSION=2.5.17

# Instala bundler
RUN gem install bundler -v $BUNDLER_VERSION

# Crea usuario seguro
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Crea y da permisos a la carpeta de bundle
RUN mkdir -p $BUNDLE_PATH && chown -R rails:rails $BUNDLE_PATH

# Copia Gemfile y Gemfile.lock y haz bundle install como usuario root
COPY Gemfile Gemfile.lock ./
RUN bundle config set path "$BUNDLE_PATH" && bundle install

# Copia la app completa
COPY . .

# Precompila bootsnap
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Asigna todos los permisos a rails
RUN chown -R rails:rails /rails

# Cambia a usuario rails
USER rails

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]

CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
