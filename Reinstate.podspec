#
# Be sure to run `pod lib lint Reinstate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Reinstate'
  s.version          = '0.3.2'
  s.summary          = 'Leverage child view controllers to manage the state of your app and keep each view controller small.'

  s.description      = <<-DESC
When managing an app with complex state, it’s easy for your view controllers to balloon in size. Make use of Reinstate’s utilities to create, display and remove child view controllers, can keep each individual view controller simple.
                       DESC

  s.homepage         = 'https://github.com/nevillco/Reinstate'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nevillco' => 'connor.neville16@gmail.com' }
  s.source           = { :git => 'https://github.com/nevillco/Reinstate.git', :tag => s.version.to_s }

  s.swift_version = '4.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'Source/**/*'
end
