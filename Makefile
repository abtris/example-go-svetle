# https://suva.sh/posts/well-documented-makefiles/#simple-makefile
.DEFAULT_GOAL:=help
SHELL:=/bin/bash

.PHONY: help all build build-ui build-all run test clean watch

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

all: build test  ## Build + test

build-server: ## Build server
	@echo "Building Server..."
	@go build -o main examples/stdlib/main.go

build-ui: ## Build UI
	@echo "Building UI..."
	@cd ui && npm install && npm run build


build: build-ui build-server ## Build the entire application


run: ## Run the application
	@go run examples/stdlib/main.go

test: ## Test the application
	@echo "Testing..."
	@go test ./... -v


clean: ## Clean the binary
	@echo "Cleaning..."
	@rm -f main


watch: ## Live Reload
	@if command -v air > /dev/null; then \
			air; \
			echo "Watching...";\
		else \
			read -p "Go's 'air' is not installed on your machine. Do you want to install it? [Y/n] " choice; \
			if [ "$$choice" != "n" ] && [ "$$choice" != "N" ]; then \
				go install github.com/air-verse/air@latest; \
				air; \
				echo "Watching...";\
			else \
				echo "You chose not to install air. Exiting..."; \
				exit 1; \
			fi; \
		fi




