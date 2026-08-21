.PHONY: lint format build test

# Lint using .swiftlint.yml (auto-detected). Non-mutating.
lint:
	swiftlint lint

# Auto-format in place using .swiftformat (auto-detected).
format:
	swiftformat .

build:
	swift build

test:
	swift test
