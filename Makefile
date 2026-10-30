# Tracelyt Query Engine - Build & Verification Targets
.PHONY: help validate test build docs-check clean

# Default target
all: help

help:
	@echo "Tracelyt Query Engine - Available Targets:"
	@echo "  make validate    - Runs static code analysis (Checkstyle)"
	@echo "  make test        - Executes unit tests and context smoke tests"
	@echo "  make build       - Builds executable JAR without running tests"
	@echo "  make docs-check  - Validates markdown documentation links"
	@echo "  make clean       - Cleans target build artifacts"
	@echo ""
	@echo "Windows Equivalent Commands:"
	@echo "  .\\mvnw.cmd checkstyle:check"
	@echo "  .\\mvnw.cmd test"
	@echo "  .\\mvnw.cmd clean package -DskipTests"

validate:
	./mvnw checkstyle:check

test:
	./mvnw clean test

build:
	./mvnw clean package -DskipTests

docs-check:
	python tools/validate_docs.py

clean:
	./mvnw clean
