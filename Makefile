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

#📦 setup: @ Execute mix setup in all the umbrella apps
setup:
	@mix setup
	MIX_ENV=test mix setup

#⚗️ start: @ Starts a iex session
start:
	@iex -S mix

#⚗️ start: @ Starts a iex session
start.dev:
	@iex -S MIX_ENV=dev mix

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

#start: @ ‍💻 Starts the service
# start: SHELL:=/bin/bash
# start:
# 	@MIX_ENV=prod && iex -S mix

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