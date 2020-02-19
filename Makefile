# Helper targets for my rails projects
#
# Note: .PHONY is a hack to ensure make runs a target even if a file/directory
# with the same name exists.
#

DEFAULT_GOAL := help
BE = bundle exec

.PHONY: help
help: ## Print this message
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | \
	  sort | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: dependencies
dependencies: ## Install Ubuntu dependencies for building
	apt update && apt install libpq-dev

.PHONY: docker-env-up
docker-env-up:  ## Start docker environment
	docker-compose up -d && sleep 1

.PHONY: docker-env-down
docker-env-down: ## Stop docker environment
	docker-compose down

.PHONY: docker-env-clean
docker-env-clean: ## Stop docker environment and wipe data
	docker-compose down -v

.PHONY: test-all
test-all: test-integration ## Run all tests

.PHONY: test-integration
test-integration: docker-env-up ## Run rails tests
	$(BE) rails db:setup && \
	    $(BE) rails db:migrate && \
	    $(BE) rails test
