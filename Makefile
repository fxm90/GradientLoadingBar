##
## ================
## Gradient Loading Bar Makefile
## ================
##


######### Tools #########

SWIFTFORMAT := swiftformat
SWIFTLINT   := swiftlint
XCODEBUILD  := xcodebuild


######### SwiftFormat #########

##    $ make verify-swiftformat-installed
##        Verifies that SwiftFormat is installed on the system.
##
.PHONY: verify-swiftformat-installed
verify-swiftformat-installed:
	@command -v $(SWIFTFORMAT) >/dev/null 2>&1 || { \
		echo "warning: SwiftFormat not installed!"; \
		exit 1; \
	}

##    $ make format
##        Uses SwiftFormat to automatically reformat the codebase according
##        to our guidelines.
##
.PHONY: format
format: verify-swiftformat-installed
	@$(SWIFTFORMAT) ./
##    $ make format-check
##        Runs SwiftFormat in lint mode (no changes). Intended for CI.
##
.PHONY: format-check
format-check: verify-swiftformat-installed
	@$(SWIFTFORMAT) --lint ./


######### SwiftLint #########

##    $ make verify-swiftlint-installed
##        Verifies that SwiftLint is installed on the system.
##
.PHONY: verify-swiftlint-installed
verify-swiftlint-installed:
	@command -v $(SWIFTLINT) >/dev/null 2>&1 || { \
		echo "warning: SwiftLint not installed!"; \
		exit 1; \
	}

##    $ make lint
##        Runs SwiftLint on the whole project according to the linting configuration files.
##
.PHONY: lint
lint: verify-swiftlint-installed
	@$(SWIFTLINT) --strict ./


######### XcodeBuild #########

##    $ make verify-xcodebuild-installed
##        Verifies that xcodebuild is installed on the system.
##
.PHONY: verify-xcodebuild-installed
verify-xcodebuild-installed:
	@command -v $(XCODEBUILD) >/dev/null 2>&1 || { \
		echo "warning: xcodebuild not installed!"; \
		exit 1; \
	}

##    $ make test
##        Runs the test suite using xcodebuild.
##
.PHONY: test
test: verify-xcodebuild-installed
	@$(XCODEBUILD) \
		test \
		-scheme GradientLoadingBar \
		-destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' \
		-enableCodeCoverage YES
	
##    $ make build-example-application
##        Builds the Example Application using xcodebuild.
##
.PHONY: build-example-application
build-example-application: verify-xcodebuild-installed
	@$(XCODEBUILD) \
		build \
		-project Example/GradientLoadingBarExample.xcodeproj \
		-scheme GradientLoadingBarExample \
		-destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2'
