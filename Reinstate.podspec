#
# Be sure to run `pod lib lint Reinstate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Reinstate'
  s.version          = '0.5.0'
  s.summary          = 'A toolbox for better view controller management in iOS.'

  s.description      = <<-DESC
  It is common to leverage container view controllers in iOS, like UINavigationController and UITabBarController. It is less common to fully utilize the pattern of view controller composition to keep your code clean and easy to reason with. Reinstate provides a variety of tools to help you compose a hierarchy of view controllers, each one small and with a single focus.
                       DESC

  s.homepage         = 'https://github.com/nevillco/Reinstate'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nevillco' => 'connor.neville16@gmail.com' }
  s.source           = { :git => 'https://github.com/nevillco/Reinstate.git', :tag => s.version.to_s }

  s.swift_version = '4.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'Source/**/*'
end
