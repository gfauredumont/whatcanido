# Use this file with Docker
# https://docs.docker.com/engine/installation/
FROM ruby:3.1.2-slim-buster

RUN apt-get update -qq                              \
  && apt-get install -yq --no-install-recommends    \
  build-essential                                   \
  libpq-dev                                         \
  gnupg2                                            \
  curl                                              \
  locales                                           \
  shared-mime-info                                  \
  git                                               \
  && apt-get clean                                  \
  && rm -rf /var/cache/apt/archives/*               \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  \
  && truncate -s 0 /var/log/*log

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt buster-pgdg main' > /etc/apt/sources.list.d/pgdg.list

# Prepare package source for NodeJS (allows latest stable version (yarn needs nodejs >= 4) and includes npm)
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq                              \
  && apt-get install -yq --no-install-recommends    \
  nodejs                                            \
  postgresql-client-14                              \
  yarn                                              \
  && apt-get clean

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8    \
  && LANGUAGE en_US:en  \
  && BUNDLE_JOBS 4      \
  && BUNDLE_RETRY 3

# UPDATE Bundler to version 2
RUN gem update --system &&   \
  gem install bundler

# Force Bundler to work in parallel
RUN bundle config --global jobs 4               \
  && echo 'gem: --no-document' > /root/.gemrc   \
  && gem install foreman

RUN mkdir /webapp
WORKDIR /webapp
ENV PATH $PATH:/webapp/bin

COPY Gemfile /webapp/Gemfile
COPY Gemfile.lock /webapp/Gemfile.lock
RUN bundle install

COPY package.json /webapp/package.json
COPY yarn.lock /webapp/yarn.lock
RUN yarn install

COPY . /webapp

CMD ["bash"]
