GREEN  		:= $(shell tput -Txterm setaf 2)
YELLOW 		:= $(shell tput -Txterm setaf 3)
WHITE  		:= $(shell tput -Txterm setaf 7)
CYAN   		:= $(shell tput -Txterm setaf 6)
RESET  		:= $(shell tput -Txterm sgr0)

.PHONY: all mongo mssql

all: help

kafka: ## Start a Kafka Broker
	@docker compose -f ./docker-compose.yaml up -d zookeeper broker

kafka-cluster: ## Start a 3 node Kafka Cluster
	@docker compose -f ./docker-compose.yaml up -d zookeeper-1 zookeeper-2 zookeeper-3 broker-1 broker-2 broker-3

mongo: ## Start a MongoDB server
	@docker compose -f ./docker-compose.yaml up -d mongo

mssql: ## Start a MSSQL server
	@docker compose -f ./docker-compose.yaml up -d mssql

mysql: ## Start a MySQL server
	@docker compose -f ./docker-compose.yaml up -d mysql

stop: ## Stop services
	@docker compose -f ./docker-compose.yaml stop

down: ## Stop and remove containers, networks
	@docker compose -f ./docker-compose.yaml down -v --remove-orphans

clean: ## Clean up docker (Stop containers, prune network, containers and images, remove volumes)
	@docker stop $(shell docker ps -a -q) || true;
	@docker network prune -f || true;
	@docker container prune -f || true;
	@docker image prune -af || true;
	@docker volume rm $(shell docker volume ls -qf dangling=true) || true;

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
