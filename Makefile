.DEFAULT_GOAL := help

PROJECT_SLUG  := deep-serve

COLOR         :=\033[0;32m
NC            :=\033[00m


.PHONY: uv ## Install uv, a virtual environment manager
uv:
	curl -LsSf https://astral.sh/uv/install.sh | sh

.PHONY: format ## Auto-format source files
format:
	uv run ruff check --fix .
	uv run ruff format .

.PHONY: lint ## Run linter python source files
lint:
	uv run ruff check .
	uv run ruff format --check .

.PHONY: typecheck ## Run type checks with mypy
typecheck:
	uv run mypy .

.PHONY: test ## Run all tests
test:
	uv run pytest

.PHONY: clean ## Clear local caches and build artifacts
clean:
	rm -rf dist
	rm -rf .cache
	rm -rf .hypothesis
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]'`
