PACKAGE_FILE := "IOSApp.xcworkspace/xcshareddata/swiftpm/Package.resolved"

.PHONY: swiftpm
swiftpm:
	@# Restore Package.resolved, which gets deleted when re-generating the project/workspace.
	@# Or, it gets deleted by Xcode.
	@# Only do this if the file was completely deleted.
	@# Otherwise, the user could be modifying packages which updates Package.resolved, so do not git restore it.
	@if [ ! -f "$(url-image)" ]; then \
        echo "Restoring Package.resolved..."; \
        git restore "$(url-image)"; \
        xcodebuild -resolvePackageDependencies; \
    fi
