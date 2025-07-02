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

ENV RAILS_ENV=development \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLER_VERSION=2.5.17

# Instala bundler
RUN gem install bundler -v $BUNDLER_VERSION

# Copia gemas y las instala
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia la app completa
COPY . .

# Precompila bootsnap
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Agrega usuario seguro
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
