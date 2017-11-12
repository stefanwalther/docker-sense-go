
help: ## Call the help
	@echo ''
	@echo 'Available commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ''
.PHONY: help

d-build: ## Build the container
	docker build --no-cache --force-rm -t stefanwalther/sense-go .
.PHONY: d-build

gen-readme: ## Generate the README.md (using docker-verb)
	docker run --rm -v ${PWD}:/opt/verb stefanwalther/verb
.PHONY: gen-readme

run: ## Run sense-go locally (for testing purposes)
	docker run --rm -v ${PWD}:/opt/sense-go stefanwalther/sense-go build
.PHONY: run

cci-local: ## Run CircleCI-2 locally
	echo $DOCKER_USER
	circleci build -e DOCKER_USER="stefanwalther" -e DOCKER_PASS=$(DOCKER_PASS)
.PHONY: cci-local

test:
	@./test/test.sh
.PHONY: test
