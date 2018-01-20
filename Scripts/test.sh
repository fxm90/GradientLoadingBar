#
# test.sh
# Created by Felix Mau (http://felix.hamburg)
#
# Based on:
#  - http://www.mokacoding.com/blog/running-tests-from-the-terminal/
#  - https://github.com/supermarin/xcpretty#usage
#  - https://www.objc.io/issues/6-build-tools/travis-ci/
#

xcodebuild \
  -workspace Example/GradientLoadingBar.xcworkspace \
  -scheme GradientLoadingBar-Example \
  -enableCodeCoverage YES \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone X,OS=11.2' \
  ONLY_ACTIVE_ARCH=NO \
  test | xcpretty && exit ${PIPESTATUS[0]}