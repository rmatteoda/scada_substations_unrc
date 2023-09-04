
ARG BUILDER_IMAGE=elixir:1.15.4-otp-25
# ARG RUNNER_IMAGE=alpine:3.17.2

FROM ${BUILDER_IMAGE} as builder

# Set the release type, this will be usefull in the future if we happen to 
# separate the releses and deployments. More changes to this Dockerfile should 
# be needed as well as the rel/overlays/bin scripts.
# ARG release_type=full_node

# RUN apk update && apk upgrade && \
#   apk add postgresql-client && \
#   apk add nodejs npm && \
#   apk add build-base && \
#   rm -rf /var/cache/apk/*

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

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/runtime.exs

# COPY rel rel
RUN mix release

# EXPOSE 4000

COPY entrypoint.sh ./
#_build/${MIX_ENV}/rel/full_node

# set runner ENV
# ENV MIX_ENV="prod"

# # Only copy the final release from the build stage
# COPY --from=builder --chown=nobody:nobody /app/_build/${MIX_ENV}/rel/full_node ./

# USER nobody
# ENV HOME=/app

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]