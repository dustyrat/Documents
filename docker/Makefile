GREEN  		:= $(shell tput -Txterm setaf 2)
YELLOW 		:= $(shell tput -Txterm setaf 3)
WHITE  		:= $(shell tput -Txterm setaf 7)
CYAN   		:= $(shell tput -Txterm setaf 6)
RESET  		:= $(shell tput -Txterm sgr0)

DOCKER_COMPOSE ?= ./docker-compose.yaml
ENV_FILE ?= .env
ACTION ?= stop
ARGS ?=
CONTAINERS ?=

.PHONY: all login mongo mssql stop down clean help

all: help

## Docker:
compose: ## Docker Compose (usage: make compose ENV_FILE=.env ACTION=up ARGS=-d CONTAINERS=postgres)
	docker compose -f $(DOCKER_COMPOSE) --env-file $(ENV_FILE) $(ACTION) $(ARGS) $(CONTAINERS)

clean: ## Clean up docker (Stop containers, prune network, containers and images, remove volumes)
	@docker stop $(shell docker ps -a -q) || true;
	@docker network prune -f || true;
	@docker container prune -f || true;
	@docker image prune -af || true;
	@docker volume rm $(shell docker volume ls -qf dangling=true) || true;

down: ## Stop and remove composed containers and networks
	@${MAKE} compose ACTION=down ARGS="-v --remove-orphans"

stop: ## Stop services
	@${MAKE} compose ACTION=stop

## Docker Containers:
cassandra: ## Start a Cassandra Database
	@${MAKE} compose ACTION=up CONTAINERS=cassandra

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

swagger-editor: ## Start swagger-editor
	@${MAKE} compose ACTION=up CONTAINERS=swagger-editor ARGS=-d

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
