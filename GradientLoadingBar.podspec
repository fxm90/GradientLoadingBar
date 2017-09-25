Pod::Spec.new do |s|
  s.name = 'GradientLoadingBar'
  s.version = '1.1.3'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'An animated gradient loading bar.'
  s.description = 'An animated gradient loading bar. Inspired by http://www.cssscript.com/ios-style-gradient-progress-bar-with-pure-css-css3/'
  s.homepage = 'https://github.com/fxm90/GradientLoadingBar'
  s.screenshot  = 'http://felix.hamburg/files/github/gradient-loading-bar/screen.gif'
  s.author = { 'Felix Mau' => 'contact@felix.hamburg' }

  s.source       = { :git => 'https://github.com/fxm90/GradientLoadingBar.git', :tag => '1.1.3' }
  s.source_files = 'GradientLoadingBar', 'GradientLoadingBar/**/*.swift'

  s.platform     = :ios, '9.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end