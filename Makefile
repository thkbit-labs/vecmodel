.DEFAULT_GOAL := help

PROJECT_SLUG  := vecmodel

COLOR         :=\033[0;32m
NC            :=\033[00m


.PHONY: help
help: ## Show this help message
	@echo ''
	@echo 'Available targets:'
	@awk -F':|##' '/^[a-zA-Z0-9._-]+:.*?##/ {printf "  $(COLOR)%-15s$(NC) %s\n", $$1, $$3}' $(MAKEFILE_LIST)
	@echo ''

.PHONY: uv
uv: ## Install uv, a virtual environment manager
	@command -v uv >/dev/null 2>&1 || (echo "uv not found. Installing..." && curl -LsSf https://astral.sh/uv/install.sh | sh)

.PHONY: format
format: ## Auto-format source files
	uv run ruff check --fix .
	uv run ruff format .

.PHONY: lint
lint: ## Run linter python source files
	uv run ruff check .
	uv run ruff format --check .

.PHONY: typecheck
typecheck: ## Run type checks with mypy
	uv run mypy .

.PHONY: test
test: ## Run all tests
	uv run pytest

.PHONY: clean
clean: ## Clear local caches and build artifacts
	rm -rf dist
	rm -rf .cache
	rm -rf .hypothesis
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]'`
