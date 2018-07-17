#
# Be sure to run `pod lib lint Reinstate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Reinstate'
  s.version          = '0.6.4'
  s.summary          = 'A toolbox for better view controller management in iOS.'

  s.description      = <<-DESC
  Leverage view controller containment to write cleaner, more readable UI code.
                       DESC

  s.homepage         = 'https://github.com/nevillco/Reinstate'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Connor Neville' => 'connor.neville16@gmail.com' }
  s.source           = { :git => 'https://github.com/nevillco/Reinstate.git', :tag => s.version.to_s }

  s.swift_version = '4.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'Source/**/*'
end
