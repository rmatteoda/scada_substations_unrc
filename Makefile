.PHONY: help devops.up devops.down docker.build docker.stop docker.delete docker.run docker.connect release.start release.connect setup check dialyzer dialyzer.plt lint lint.ci test coveralls coveralls.html grafana.wipe grafana.save grafana.load

COMPOSE_PROJECT_NAME=foss_umbrella_local
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

#🧪 test: @ Execute mix test for all the umbrella apps - add app=app_name to test only a specific app
test:
	@MIX_ENV=test mix test

#🧪 test.only: @ Execute mix test tagged with TAG for all the umbrella apps - add app=app_name to test only a specific app
test.only: TAG:=wip
test.only:
	@MIX_ENV=test mix test --only ${TAG}