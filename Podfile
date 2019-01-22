# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ChattoSauce' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for ChattoSauce
  
  pod 'FMDB'
  # pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'

  # XMPP
  pod 'XMPPFramework', :git => 'https://github.com/robbiehanson/XMPPFramework.git', :branch => 'master'
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
               config.build_settings['SWIFT_VERSION'] = '4.1'
          end
      end
  end

  # Reactive Cocoa FRP
  pod 'ReactiveObjC', '~> 3.1'

end
