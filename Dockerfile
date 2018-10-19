FROM ruby:2.5.1-alpine3.7
MAINTAINER Jobandtalent Team <backend.team@jobandtalent.com>

ENV RUBY_VERSION=2.5.1
ENV BUNDLE_SILENCE_ROOT_WARNING=1

LABEL app="fichador" stack.binary="ruby" stack.version="alpine-2.5.1"

WORKDIR /app

RUN apk add --no-cache ca-certificates libcurl libressl libxml2 libxslt postgresql-libs tzdata

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN set -ex && \
    apk add --no-cache --virtual .ruby-bundler \
    build-base git \
    libxml2-dev libxslt-dev postgresql-dev libressl-dev && \
    bundle install -j 4 --no-cache && \
    apk del .ruby-bundler

COPY . .

CMD ["rails", "server", "puma", "-b", "0.0.0.0"]
ENTRYPOINT ["bundle", "exec"]
ARG PORT=3000
ENV PORT=${PORT}
EXPOSE ${PORT}
