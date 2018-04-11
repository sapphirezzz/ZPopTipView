#
# Be sure to run `pod lib lint ZPopTipView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZPopTipView'
  s.version          = '0.3.1'
  s.summary          = 'A short description of ZPopTipView.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sapphirezzz/ZPopTipView'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sapphirezzz' => 'zhengzuanzhe@gmail.com' }
  s.source           = { :git => 'https://github.com/sapphirezzz/ZPopTipView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'ZPopTipView/Classes/**/*'
  s.resources = ['ZPopTipView/Assets/Images.xcassets']
  s.frameworks = 'UIKit'
end
