# Makefile for qalio-api

# Main project and subprojects
MAIN_PROJECT := qalio-api
SUBPROJECTS := nightfox rusty basher amazing \
               livingston turk virgil linus \
               matsui nagel benedict baron \
               woude lahiri diaz greco \
               bloom holzer adams sponder \
               robin

# Organization name
ORG_NAME := qalio

# Directories
PROTO_DIR := proto
BUILD_DIR := build
DEPLOY_DIR := deploy

# Generate a unique tag using a timestamp or a version number
TAG=$(shell date +'%Y%m%d%H%M%S')

# Default target
.PHONY: all
all: build

# Build all subprojects
.PHONY: build
build: $(SUBPROJECTS)

# Build each subproject
$(SUBPROJECTS):
	@echo "Building $@..."
	@$(MAKE) -C $@ build

# Generate Protobuf code using buf for each subproject
.PHONY: proto
proto:
	@echo "Generating Protobuf code using buf..."
	@for dir in $(SUBPROJECTS); do \
		echo "Processing $$dir..."; \
		cd $$dir && buf generate $(PROTO_DIR); \
	done

# Lint Protobuf definitions
.PHONY: lint
lint:
	@echo "Linting Protobuf definitions..."
	@for dir in $(SUBPROJECTS); do \
		echo "Linting $$dir..."; \
		cd $$dir && buf lint $(PROTO_DIR); \
	done

# Format Protobuf definitions
.PHONY: format
format:
	@echo "Formatting Protobuf definitions..."
	@for dir in $(SUBPROJECTS); do \
		echo "Formatting $$dir..."; \
		cd $$dir && buf format -w $(PROTO_DIR); \
	done

# Clean build directories
.PHONY: clean
clean:
	@echo "Cleaning build directories..."
	@for dir in $(SUBPROJECTS); do \
		echo "Cleaning $$dir..."; \
		$(MAKE) -C $$dir clean; \
	done

# Deploy using kamal
.PHONY: deploy
deploy:
	@echo "Deploying services using kamal..."
	@kamal deploy --repo=$(ORG_NAME)/$(MAIN_PROJECT) --services=$(SUBPROJECTS)

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	@for dir in $(SUBPROJECTS); do \
		echo "Testing $$dir..."; \
		$(MAKE) -C $$dir test; \
	done

# Push new changes up with unique commit messages and the same tag across all projects
.PHONY: push
push:
	@echo "Pushing new changes up with tag v-$(TAG)..."
	@for dir in $(SUBPROJECTS); do \
		echo "Processing $$dir..."; \
		cd $$dir && git add . && git commit -m "$$dir: v-$(TAG)" && git tag v-$(TAG) && git push && git push origin v-$(TAG); \
		cd ..; \
	done

# Help command
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make build    - Build all subprojects"
	@echo "  make proto    - Generate Protobuf code using buf"
	@echo "  make lint     - Lint Protobuf definitions"
	@echo "  make format   - Format Protobuf definitions"
	@echo "  make clean    - Clean build directories"
	@echo "  make deploy   - Deploy services using kamal"
	@echo "  make test     - Run tests for all subprojects"
	@echo "  make push     - Push new changes up"
	@echo "  make help     - Show this help message"
