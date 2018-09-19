#
# test.sh
# Created by Felix Mau (https://felix.hamburg)
#
# Based on:
#  - http://www.mokacoding.com/blog/running-tests-from-the-terminal/
#  - https://github.com/supermarin/xcpretty#usage
#  - https://www.objc.io/issues/6-build-tools/travis-ci/
#

#!/bin/bash
cd Example/

xcodebuild \
  -workspace GradientLoadingBar.xcworkspace \
  -scheme GradientLoadingBar-Example \
  -enableCodeCoverage YES \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone X,OS=11.2' \
  ONLY_ACTIVE_ARCH=NO \
  test | xcpretty && exit ${PIPESTATUS[0]}
