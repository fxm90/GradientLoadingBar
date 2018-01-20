#
# swift-lint.sh
# Created by Felix Mau (http://felix.hamburg)
#

# Run "swiftlint" and break build on any warnings
cd Example && swiftlint --strict
