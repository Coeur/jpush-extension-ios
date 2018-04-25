#
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JPush-extension-iOS'
  s.version          = '1.1.1'
  s.summary          = 'Unofficially supported JPush extension iOS SDK Pod.'
  s.description      = 'Unofficially supported JPush extension iOS SDK Pod.\n https://docs.jiguang.cn'
  
  s.homepage         = 'https://www.jiguang.cn/'
  s.license          = { :type => 'Copyright', :text => 'Copyright jpush.cn' }
  s.author           = { 'JPush' => 'support@jpush.cn' }
  
  s.source           = { :http => 'https://www.jiguang.cn/downloads/sdk/ios', :type => :zip }
  #s.source           = { :http => 'https://sdkfiledl.jiguang.cn/build/jpush-ios-3.0.9-release.zip' }
  
  # https://developer.apple.com/documentation/usernotifications/unnotificationserviceextension
  s.ios.deployment_target = '10.0'
  
  #s.user_target_xcconfig = { 'SWIFT_OBJC_BRIDGING_HEADER' => '$(PODS_ROOT)/Headers/Public/JPush-extension-iOS/JPushNotificationExtensionService.h' }
  
  s.source_files = 'jpush-ios-*-release/Lib/JPushNotificationExtensionService.h'
  s.vendored_libraries = 'jpush-ios-*-release/Lib/jpush-extension-ios-*.a'
  s.frameworks = 'Foundation'
  s.weak_frameworks = 'UserNotifications'
  s.libraries = 'z', 'resolv'
end
