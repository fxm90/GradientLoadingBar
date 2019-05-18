#
# test.sh
# Created by Felix Mau (https://felix.hamburg)
#
# Based on:
#  - http://www.mokacoding.com/blog/running-tests-from-the-terminal/
#  - https://github.com/supermarin/xcpretty#usage
#  - https://www.objc.io/issues/6-build-tools/travis-ci/
#  - https://github.com/codecov/example-swift
#

#!/bin/bash
cd Example/

xcodebuild \
  -workspace LightweightObservable.xcworkspace \
  -scheme LightweightObservable-Example \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone XR,OS=12.2' \
  build test | xcpretty && exit ${PIPESTATUS[0]}
