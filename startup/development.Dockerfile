FROM ruby:2.6.6-alpine3.12

RUN apk add --no-cache --update git

ARG bundler_version=2.1.4
# usually set via docker-compose.yml
ARG exercism_config_version
ARG config_sha1

ENV EXERCISM_CONFIG_VERSION=${exercism_config_version}

WORKDIR /ver
RUN echo $exercism_config_version > config_version && \
    echo $config_sha1 > config_sha1

WORKDIR /usr/src/
RUN git clone https://github.com/exercism/config.git exercism_config
WORKDIR /usr/src/exercism_config
RUN git config --global advice.detachedHead false && \
    git checkout v${EXERCISM_CONFIG_VERSION}

RUN gem install bundler:${bundler_version} && \
    bundle install

COPY ./src/shell /
COPY ./src/exercism_logo.txt /etc

ENTRYPOINT cat /etc/exercism_logo.txt && \
    echo && echo "Exercism v3" && echo && \
    echo "config gem: v${EXERCISM_CONFIG_VERSION}" && echo && \
    bundle exec setup_exercism_config && \
    bundle exec setup_exercism_local_aws
