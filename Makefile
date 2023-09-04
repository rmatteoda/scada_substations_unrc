.PHONY: help start setup check dialyzer dialyzer.plt lint lint.ci test

export MIX_ENV ?= dev
ENV_FILE ?= .env
export COMPOSE_PROJECT_NAME = scada_unrc_local

# add env variables if needed
ifneq (,$(wildcard ${ENV_FILE}))
	include ${ENV_FILE}
    export
endif

# if ECTO_HOST are set to a running docker container, revert to default (localhost) for the purposes of mix setup
define unset_docker_container_hosts
	for hostName in "ECTO_HOST $(ECTO_HOST)" "PROMETHEUS_HOST $(PROMETHEUS_HOST)"; do \
		docker ps --format "{{.Names}}" | grep -q -E `echo $$hostName | cut -d' ' -f2` && unset `echo $$hostName | cut -d' ' -f1` || :; \
	done
endef

default: help
#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

clean:
	@true
	@rm -rf node_modules
	@mix clean
	@echo Cleaning complete...

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

#🐳 docker.build: @ Build the full_node docker image
docker.build:
	@cp ./devops/local_dev/Dockerfile ./
	@docker build ./
	@ rm ./Dockerfile

docker.up:
	@cp ./devops/local_dev/Dockerfile ./
	@cp ./devops/local_dev/docker-compose.yml ./
	@MIX_ENV=prod
	@docker compose up -d
	@ rm ./Dockerfile
	@ rm ./docker-compose.yml

#⚙️  devops.down:@   Ends the `docker-compose.yaml` services located in /devops/local_dev
docker.down:
	@cp ./devops/local_dev/Dockerfile ./
	@cp ./devops/local_dev/docker-compose.yml ./
	@docker compose --profile healthy down
	@ rm ./Dockerfile
	@ rm ./docker-compose.yml

#🐳 docker.stop: @ Stop the full_node docker instance
docker.stop:
	@docker stop full_node || true

#🐳 docker.delete: @ Delete the full_node docker instance
docker.delete:
	@docker rm full_node || true

#🐳 docker.run: @ Run the full_node docker instance
docker.run:
	@docker run --name full_node \
		--network $(COMPOSE_PROJECT_NAME)_open \
		-p 9568:9568 \
		-p $(ADMIN_INTERNAL_PORT):$(ADMIN_INTERNAL_PORT) \
		-p $(GATEWAY_INTERNAL_PORT):$(GATEWAY_INTERNAL_PORT) \
		--env-file .env \
		$(EXTRA_ARGS) \
		full_node

#🐳 docker.run.daemon: @ Run the full_node docker instance as a background service
docker.run.daemon: EXTRA_ARGS=--detach
docker.run.daemon: docker.run

#⚗️  docker.start: @   Build and (re)start the full_node instance
docker.start: docker.build docker.stop docker.delete docker.run

#⚗️  docker.start.daemon: @   Build and (re)start the full_node instance as a background service
docker.start.daemon: docker.build docker.stop docker.delete docker.run.daemon

#🐳 docker.connect: @ Connect to the full_node running container
docker.connect:
	@docker exec -it full_node /bin/bash
