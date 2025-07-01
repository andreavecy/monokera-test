# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libvips \
    libjemalloc2 \
    curl \
    postgresql-client \
    git \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV=development \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle"

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails

EXPOSE 3001

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
