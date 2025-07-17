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
uv: # Check uv 
	@command -v uv >/dev/null 2>&1 || \
	(echo "uv not found. Please install uv manually: https://astral.sh/uv/" && exit 1)

.PHONY: install
install: ## Install package, dependencies, and pre-commit for local development
	uv sync --all-packages
	pre-commit install  --install hooks

.PHONY: upgrade
upgrade: ## Update all dependencies
	uv lock --upgrade
	pre-commit autoupdate

.PHONY: lint
lint: ## Run linter python source files
	uv run ruff check .
	uv run ruff format --check .

.PHONY: typecheck
typecheck: ## Perform type-checking
	uv run mypy .

.PHONY: test
test: ## Run all tests
	uv run pytest -m "not slow"

.PHONY: build
build: ## Build package
	uv build --all-packages

.PHONY: clean
clean: ## Clear local caches and build artifacts
	rm -rf dist
	rm -rf .cache
	rm -rf .hypothesis
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]'`
