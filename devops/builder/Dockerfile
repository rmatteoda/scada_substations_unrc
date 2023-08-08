
ARG BUILDER_IMAGE=elixir:1.15.4-otp-25-alpine
ARG RUNNER_IMAGE=alpine:3.17.2

FROM ${BUILDER_IMAGE} as builder
# ARG GITHUB_OAUTH_TOKEN

# Set the release type, this will be usefull in the future if we happen to 
# separate the releses and deployments. More changes to this Dockerfile should 
# be needed as well as the rel/overlays/bin scripts.
# ARG release_type=full_node

# install build dependencies
RUN apk add --no-cache build-base git curl wget nodejs npm openssl cmake boost-dev ca-certificates

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock ./

RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# Compile the release
RUN mix compile

# Changes to config/runtime.exs and config/aws_secrets don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

COPY entrypoint.sh /app/_build/${MIX_ENV}/rel/full_node

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE} as candidate

RUN apk add --no-cache openssl ncurses-libs libstdc++ libgcc curl bash nano ca-certificates redis

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody:nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:nobody /app/_build/${MIX_ENV}/rel/full_node ./

# We need to also copy the aws_secrets.exs config given that for now it's being loaded on runtime
COPY --from=builder --chown=nobody:nobody /app/config/aws_secrets.exs ./bin/config/

USER nobody
ENV HOME=/app

RUN chmod 554 /app/entrypoint.sh

ENTRYPOINT ["sh", "entrypoint.sh", "deploy"]