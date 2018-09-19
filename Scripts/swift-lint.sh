#
# swift-lint.sh
# Created by Felix Mau (https://felix.hamburg)
#

#!/bin/bash
cd Example/

# Path config
PODS_ROOT="Pods"
SWIFTLINT="${PODS_ROOT}/SwiftLint/swiftlint"

if [ ! -f "$SWIFTLINT" ]; then
    echo "warning: SwiftLint not installed!"
    exit 1
fi

# Run "swiftlint" and break build on any warnings.
$SWIFTLINT --strict
