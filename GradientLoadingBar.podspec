#
# Be sure to run `pod lib lint GradientLoadingBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GradientLoadingBar'
  s.version          = '2.0.3'
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
  s.screenshots      = 'https://felix.hamburg/files/github/gradient-loading-bar/screen.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Felix Mau' => 'contact@felix.hamburg' }
  s.source           = { :git => 'https://github.com/fxm90/GradientLoadingBar.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_fxm90'

  s.swift_version         = '5.0'
  s.ios.deployment_target = '9.0'

  s.source_files = 'GradientLoadingBar/Classes/**/*'

  # s.resource_bundles = {
  #   'GradientLoadingBar' => ['GradientLoadingBar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
s.dependency 'LightweightObservable', '~> 2.0'

end
