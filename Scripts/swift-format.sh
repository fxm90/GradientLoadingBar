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

# Run "swiftformat" with same config as in xcode as well as:
#  --dryrun: run in "dry" mode (without actually changing any files)
#  --verbose: display detailed formatting output and warnings/errors
SWIFT_FORMAT_RESULT="$($SWIFTFORMAT ../ --disable "trailingCommas" --dryrun --verbose)"
echo "$SWIFT_FORMAT_RESULT"

# Successful build if "0" files would have been updated
echo $SWIFT_FORMAT_RESULT | egrep "swiftformat completed. 0/([0-9]+) files would have been updated" --quiet