source 'https://cdn.cocoapods.org'
install! 'cocoapods', :deterministic_uuids => false
inhibit_all_warnings!

def shared_pods
  use_modular_headers!
  pod 'XKKeychain', :git => 'https://code.videolan.org/fkuehne/XKKeychain.git', :commit => '40abb8f1'
  pod 'CocoaHTTPServer', :git => 'https://code.videolan.org/fkuehne/CocoaHTTPServer.git', :commit => '08f9b818'
  pod 'AFNetworking', :git => 'https://code.videolan.org/fkuehne/AFNetworking.git', :commit => 'ee51009a' # add visionOS support
  pod 'VLCKit', '4.0.0a11'
  pod 'VLCMediaLibraryKit', '0.14.0a1'
end

target 'VLC-iOS' do
  platform :ios, '12.0'
  shared_pods
  pod 'OBSlider', :git => 'https://code.videolan.org/fkuehne/OBSlider.git', :commit => 'e60cddfe'
  pod 'InAppSettingsKit', :git => 'https://github.com/Mikanbu/InAppSettingsKit.git', :commit => 'a429840' #tvOS fix
  pod 'GoogleAPIClientForREST/Drive', '~> 1.2.1'
  pod 'GoogleSignIn', '6.2.0'
  pod 'GTMAppAuth', '~> 1.0'
  pod 'ADAL', :git => 'https://code.videolan.org/fkuehne/azure-activedirectory-library-for-objc.git', :commit => '348e94df'
  pod 'OneDriveSDK', :git => 'https://code.videolan.org/fkuehne/onedrive-sdk-ios.git', :commit => '810f82da'
  pod 'MarqueeLabel', :git => 'https://code.videolan.org/fkuehne/MarqueeLabel.git', 
                    :commit => 'e289fa32',
                    :modular_headers => true
  pod 'ObjectiveDropboxOfficial'
  pod 'PCloudSDKSwift'
  pod 'box-ios-sdk-v2', :git => 'https://github.com/fkuehne/box-ios-sdk-v2.git', :commit => '08161e74' #has a our fixes

  # debug
  pod 'SwiftLint', '~> 0.50.3', :configurations => ['Debug']

  target 'VLC-iOSTests' do
      inherit! :search_paths
  end

  use_modular_headers!
end

target 'VLC-iOS-Screenshots' do
  platform :ios, '12.0'
  inherit! :search_paths
  pod 'SimulatorStatusMagic'
end

target 'VLC-tvOS' do
  platform :tvos, '12.0'
  shared_pods
  pod 'GRKArrayDiff', :git => 'https://code.videolan.org/fkuehne/GRKArrayDiff.git'
  pod 'MetaDataFetcherKit', '~>0.5.0'

  # debug
  pod 'SwiftLint', '~> 0.50.3', :configurations => ['Debug']
end

target 'VLC-visionOS' do
  platform :visionos, '1.0'
  shared_pods
  pod 'OBSlider', :git => 'https://code.videolan.org/fkuehne/OBSlider.git', :commit => 'e60cddfe'
  pod 'MarqueeLabel', :git => 'https://code.videolan.org/fkuehne/MarqueeLabel.git', :commit => 'e289fa32'

  use_modular_headers!
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    installer_representation.pods_project.build_configurations.each do |config|
      config.build_settings['SKIP_INSTALL'] = 'YES'
      config.build_settings['ARCHS'] = 'arm64 x86_64'
      config.build_settings['CLANG_CXX_LIBRARY'] = 'libc++'
      config.build_settings['SUPPORTED_PLATFORMS'] = 'iphoneos iphonesimulator appletvos appletvsimulator xros xrsimulator'
      config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2,3,7'
    end
    
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['TVOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SUPPORTS_MACCATALYST'] = 'NO'
      
      # Enable modules for all targets
      config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
      config.build_settings['DEFINES_MODULE'] = 'YES'
      
      # Special handling for MarqueeLabel
      if target.name == 'MarqueeLabel-iOS'
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['MODULEMAP_FILE'] = '${PODS_ROOT}/MarqueeLabel/Sources/MarqueeLabel.modulemap'
        config.build_settings['PRODUCT_MODULE_NAME'] = 'MarqueeLabel'
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
        # Ensure module map directory exists
        unless Dir.exist?("${PODS_ROOT}/MarqueeLabel/Sources")
          FileUtils.mkdir_p("${PODS_ROOT}/MarqueeLabel/Sources")
        end
      end
      
      # Clean sqlite3 reference
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      new_xcconfig = xcconfig.sub('-l"sqlite3"', '')
      File.open(xcconfig_path, "w") { |file| file << new_xcconfig }
    end
  end
  
  # Create module map for MarqueeLabel if it doesn't exist
  marquee_module_path = "#{installer_representation.sandbox.root}/MarqueeLabel/Sources/MarqueeLabel.modulemap"
  unless File.exist?(marquee_module_path)
    FileUtils.mkdir_p(File.dirname(marquee_module_path))
    File.open(marquee_module_path, "w") do |f|
      f.puts <<~MODULEMAP
        framework module MarqueeLabel {
          umbrella header "MarqueeLabel.h"
          
          export *
          module * { export * }
        }
      MODULEMAP
    end
  end
end
