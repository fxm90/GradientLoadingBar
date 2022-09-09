#
# Be sure to run `pod lib lint GradientLoadingBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GradientLoadingBar'
  s.version          = '2.3.3'
  s.summary          = 'A customizable animated gradient loading bar.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A customizable animated gradient loading bar.
Inspired by https://codepen.io/marcobiedermann/pen/LExXWW
                       DESC

  s.homepage         = 'https://github.com/fxm90/GradientLoadingBar'
  s.screenshots      = 'https://raw.githubusercontent.com/fxm90/GradientLoadingBar/master/Assets/screen.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Felix Mau' => 'contact@felix.hamburg' }
  s.source           = { :git => 'https://github.com/fxm90/GradientLoadingBar.git', :tag => s.version.to_s }

  s.swift_version         = '5.5'
  s.ios.deployment_target = '9.0'

  s.source_files = 'GradientLoadingBar/**/*'

  # s.resource_bundles = {
  #   'GradientLoadingBar' => ['GradientLoadingBar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
s.dependency 'LightweightObservable', '~> 2.1'

end
