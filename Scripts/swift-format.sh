#
# swift-format.sh
# Created by Felix Mau (http://felix.hamburg)
#

#!/bin/bash
cd Example/

# Path config
PODS_ROOT="Pods"
SWIFTFORMAT="${PODS_ROOT}/SwiftFormat/CommandLineTool/swiftformat"

if [ ! -f "$SWIFTFORMAT" ]; then
    echo "warning: SwiftFormat not installed!"
    exit 1
fi

# Run "swiftformat" and break build on any warnings.
$SWIFTFORMAT ../ --lint
