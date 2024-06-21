GREEN  		:= $(shell tput -Txterm setaf 2)
YELLOW 		:= $(shell tput -Txterm setaf 3)
WHITE  		:= $(shell tput -Txterm setaf 7)
CYAN   		:= $(shell tput -Txterm setaf 6)
RESET  		:= $(shell tput -Txterm sgr0)

ENV_FILE ?= .env.local
ACTION ?= stop
ARGS ?= 
CONTAINERS ?= 

.PHONY: all mongo mssql

all: help

## Docker:
compose: ## Docker Compose (usage: make compose ENV_FILE=.env.local ACTION=up ARGS=-d CONTAINERS=postgres)
	docker compose -f ./docker-compose.yaml --env-file $(ENV_FILE) $(ACTION) $(ARGS) $(CONTAINERS)

clean: ## Clean up docker (Stop containers, prune network, containers and images, remove volumes)
	@docker stop $(shell docker ps -a -q) || true;
	@docker network prune -f || true;
	@docker container prune -f || true;
	@docker image prune -af || true;
	@docker volume rm $(shell docker volume ls -qf dangling=true) || true;

down: ## Stop and remove containers, networks
	@${MAKE} compose ACTION=down ARGS="-v --remove-orphans"

registry-destroy: ## Remove the container of the local docker registry
	@docker container rm -v registry

registry-start: ## Start a local docker registry for testing
	@docker run -d -p 5000:5000 --restart=always --name registry registry:latest

registry-stop: ## Stop the local docker registry
	@docker container stop registry

stop: ## Stop composed services
	@${MAKE} compose ACTION=stop

## Docker Containers:
kafka: ## Start a Kafka Broker
	@${MAKE} compose ACTION=up CONTAINERS="zookeeper broker"

kafka-cluster: ## Start a 3 node Kafka Cluster
	@${MAKE} compose ACTION=up CONTAINERS="zookeeper-1 zookeeper-2 zookeeper-3 broker-1 broker-2 broker-3"

mongo: ## Start a MongoDB Database
	@${MAKE} compose ACTION=up CONTAINERS=mongo

mssql: ## Start a MSSQL Database
	@${MAKE} compose ACTION=up CONTAINERS=mssql

mysql: ## Start a MySQL Database
	@${MAKE} compose ACTION=up CONTAINERS=mysql

postgres: ## Start a Postgres Database
	@${MAKE} compose ACTION=up CONTAINERS=postgres

## Help:
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "	${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
