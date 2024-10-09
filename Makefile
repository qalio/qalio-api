# Makefile for qalio-api

# Main project and subprojects
MAIN_PROJECT := qalio-api
SUBPROJECTS := nightfox rusty basher amazing \
               livingston turk virgil linus \
               matsui nagel benedict baron \
               woude lahiri diaz greco \
               bloom holzer adams sponder \
               robin joey macy

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
		cd ..; \
	done

# Lint Protobuf definitions
.PHONY: lint
lint:
	@echo "Linting Protobuf definitions..."
	@for dir in $(SUBPROJECTS); do \
		echo "Linting $$dir..."; \
		cd $$dir && buf lint $(PROTO_DIR); \
		cd ..; \
	done

# Format Protobuf definitions
.PHONY: format
format:
	@echo "Formatting Protobuf definitions..."
	@for dir in $(SUBPROJECTS); do \
		echo "Formatting $$dir..."; \
		cd $$dir && buf format -w $(PROTO_DIR); \
		cd ..; \
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
	git add . && git commit -m "api: v-$(TAG)" && git tag "v-$(TAG)" && git push && git push origin "v-$(TAG)"

# Submodule operations
.PHONY: submodule
submodule: submodule-add submodule-sync submodule-init submodule-status submodule-update

# Add a submodule
.PHONY: submodule-add
submodule-add:
	@echo "Adding submodule(s)..."
	@for dir in $(SUBPROJECTS); do \
		echo "Processing $$dir..."; \
		git submodule add git@github.com:qalio/qalio-api-$$dir.git $$dir; \
	done

# Synchronize submodules
.PHONY: submodule-sync
submodule-sync:
	@echo "Synchronizing submodule URLs..."
	@git submodule sync --recursive

# Initialize and update submodules (for fresh clones)
.PHONY: submodule-init
submodule-init:
	@echo "Initializing and updating submodules..."
	@git submodule update --init --recursive

# Check status of submodules
.PHONY: submodule-status
submodule-status:
	@echo "Checking submodule status..."
	@git submodule status --recursive

# Update submodules
.PHONY: submodule-update
submodule-update:
	@echo "Updating submodules..."
	git submodule update --remote --merge --recursive

# Delete a submodule
.PHONY: submodule-delete
submodule-delete:
	@echo "Deleting submodule(s)..."
	@for dir in $(SUBPROJECTS); do \
		echo "Removing submodule $$dir..."; \
		git submodule deinit -f $$dir; \
		rm -rf .git/modules/$$dir; \
		git rm -f $$dir; \
		rm -rf $$dir; \
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
	@echo "  make submodule         - Perform all submodule operations"
	@echo "  make submodule-add     - Add submodule(s)"
	@echo "  make submodule-sync    - Synchronize submodule URLs"
	@echo "  make submodule-init-update - Initialize and update submodules"
	@echo "  make submodule-status  - Check submodule status"
	@echo "  make submodule-update  - Update submodules"
	@echo "  make submodule-delete  - Delete submodule(s)"
	@echo "  make help     - Show this help message"
