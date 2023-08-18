.PHONY: help start setup check dialyzer dialyzer.plt lint lint.ci test

export MIX_ENV ?= dev
ENV_FILE ?= .env

# add env variables if needed
ifneq (,$(wildcard ${ENV_FILE}))
	include ${ENV_FILE}
    export
endif

default: help
#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

#📦 setup: @ Execute mix setup in all the service
setup:
	@MIX_ENV=prod mix setup

setup.dev:
	@MIX_ENV=dev mix setup

setup.test:
	@mix setup
	MIX_ENV=test mix setup

setup.all:
	@MIX_ENV=dev mix setup
	@MIX_ENV=prod mix setup
	@MIX_ENV=test mix setup

#⚗️ start: @ Starts the service
# @iex -S mix
start:
	@MIX_ENV=prod mix run --no-halt

#⚗️ start: @ Starts the service in dev env
start.dev:
	@MIX_ENV=dev mix run --no-halt

#🔍 check: @ Runs all code verifications
check: lint.ci dialyzer test

#🔍 dialyzer: @ Runs a static code analysis
dialyzer:
	@mix dialyzer --format dialyxir

#🔍 dialyzer.plt: @ Force PLT check also if lock file is unchanged useful when dealing with local deps.
dialyzer.plt:
	@mix dialyzer --force-check

#🔍 lint: @ Runs a code formatter
lint:
	@mix format
	@mix credo --strict

#🔍 lint.ci: @ Strictly runs a code formatter
lint.ci:
	@mix format --check-formatted
	@mix credo --strict

# start: @ ‍💻 Starts the service with iex
start.iex.dev: SHELL:=/bin/bash
start.iex.dev:
 			@MIX_ENV=dev && iex -S mix

#run: @ ‍💻 Run the service
run: SHELL:=/bin/bash
run:
	@MIX_ENV=prod && mix run --no-halt

#🧪 test: @ Execute mix test for all the umbrella apps - add app=app_name to test only a specific app
test:
	@MIX_ENV=test mix test

#🧪 test.only: @ Execute mix test tagged with TAG for all the umbrella apps - add app=app_name to test only a specific app
test.only: TAG:=wip
test.only:
	@MIX_ENV=test mix test --only ${TAG}