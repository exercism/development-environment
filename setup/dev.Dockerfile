#############
## Stage 1 ##
#############
FROM ruby:2.6.6-alpine3.12 as gembuilder

RUN apk add --update git build-base cmake

# bump in stack.yml then rebuild setup to force a version
# you might also want to look at the commented out code below
ARG exercism_config_version

ENV EXERCISM_CONFIG_VERSION=${exercism_config_version}

WORKDIR /ver
RUN echo $exercism_config_version > config_version

# The hard way... uncomment if you need to hack on config.
# WORKDIR /usr/src/
# RUN git clone https://github.com/exercism/config.git exercism_config
# WORKDIR /usr/src/exercism_config
# RUN git config --global advice.detachedHead false && \
#     git checkout v${EXERCISM_CONFIG_VERSION} && \
#     gem build exercism_config.gemspec && \
#     gem install *.gem


# The nice easy way, from RubyGems.
RUN [[ -z "${EXERCISM_CONFIG_VERSION}" ]] && \
    gem install exercism-config || \
    gem install exercism-config -v ${EXERCISM_CONFIG_VERSION}

# Oops, this gem is confused about whether it's needed or not.
RUN gem install aws-sdk-s3

#############
## Stage 2 ##
#############
FROM ruby:2.6.6-alpine3.12 as final
ARG exercism_config_version

ENV EXERCISM_CONFIG_VERSION=${exercism_config_version}

# Copy over the binary gems from the gembuilder
COPY --from=gembuilder /usr/local/lib/ruby/gems/2.6.0 /usr/local/lib/ruby/gems/2.6.0

# Multiple sequential copies from the same container do not work.
# https://github.com/moby/moby/issues/37965#issuecomment-426853382
RUN true
COPY --from=gembuilder /usr/local/bundle/ /usr/local/bundle

# And again
RUN true
COPY --from=gembuilder /ver /ver

COPY ./src/shell /
COPY ./src/exercism_logo.txt /etc

ENTRYPOINT cat /etc/exercism_logo.txt && \
    echo && echo "Exercism v3" && echo && \
    setup_exercism_config && \
    setup_exercism_local_aws && \
    # sleep 10 so ./bin/start does not try to restart us
    sleep 10
