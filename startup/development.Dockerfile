FROM ruby:2.6.6-alpine3.12

RUN apk add --no-cache --update git
WORKDIR /usr/src/
RUN git clone https://github.com/exercism/config.git exercism_config
WORKDIR /usr/src/exercism_config

# COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.1.4 && \
    bundle install

ENV EXERCISM_CONFIG_VERSION 0.26.0
ENV EXERCISM_CONFIG_VERSION master
ENV EXERCISM_DOCKER true
ENV EXERCISM_ENV development

COPY setup_aws.rb ./setup_aws.rb

ENTRYPOINT git pull && \
           git checkout ${EXERCISM_CONFIG_VERSION} -- . && \
           bundle exec setup_exercism_config && \
           bundle exec ruby setup_aws.rb


# ENTRYPOINT ./bin/worker
