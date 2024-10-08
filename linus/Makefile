# Directories
PROTO_DIR := proto
GEN_DIR := gen

# Build target
.PHONY: build
build: $(GEN_DIR)/go

$(GEN_DIR)/go:
	@echo "Generating Go code from Protobuf definitions..."
	@buf generate $(PROTO_DIR)

# Clean target
.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf $(GEN_DIR)

# Test target
.PHONY: test
test:
	@echo "Running tests..."
	@go test ./...
