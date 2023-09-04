
ARG BUILDER_IMAGE=elixir:1.15.4-otp-25
# ARG RUNNER_IMAGE=alpine:3.17.2

FROM ${BUILDER_IMAGE} as builder

# Set the release type, this will be usefull in the future if we happen to 
# separate the releses and deployments. More changes to this Dockerfile should 
# be needed as well as the rel/overlays/bin scripts.
ARG release_type=scada_app

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

EXPOSE 4000

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
COPY entrypoint.sh /scada_app

WORKDIR /scada_app
COPY . /scada_app

# set runner ENV
ENV MIX_ENV="prod"
ENV PATH=/home/ramiro/Documents/UNRC/scada_substations_unrc:$PATH

ENV HOME=/scada_app

ENTRYPOINT ["/scada_app/entrypoint.sh"]