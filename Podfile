
source 'https://cdn.cocoapods.org'
install! 'cocoapods', :deterministic_uuids => false
inhibit_all_warnings!
use_modular_headers! # Moved to global scope

def shared_pods
  # use_modular_headers! # Removed from here
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
  pod 'MarqueeLabel', :git => 'https://code.videolan.org/fkuehne/MarqueeLabel.git', :commit => 'e289fa32'
  pod 'ObjectiveDropboxOfficial'
  pod 'PCloudSDKSwift'
  pod 'box-ios-sdk-v2', :git => 'https://github.com/fkuehne/box-ios-sdk-v2.git', :commit => '08161e74' #has a our fixes

  # debug
  pod 'SwiftLint', '~> 0.50.3', :configurations => ['Debug']

  target 'VLC-iOSTests' do
      inherit! :search_paths
  end

  # use_modular_headers! # Removed from here
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

  # use_modular_headers! # Removed from here
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
     installer_representation.pods_project.build_configurations.each do |config|
       config.build_settings['SKIP_INSTALL'] = 'YES'
       # It's generally better to let CocoaPods and individual podspecs handle ARCHS,
       # SUPPORTED_PLATFORMS, and TARGETED_DEVICE_FAMILY.
       # Overriding them globally here can cause issues with module generation for specific platforms.
       # If your build requires these, ensure they are absolutely necessary and correctly scoped.
       # For now, these are commented out or removed as they are prime suspects for the module issue.
       # config.build_settings['ARCHS'] = 'arm64 x86_64' # Consider removing or making conditional
       config.build_settings['CLANG_CXX_LIBRARY'] = 'libc++'
       # config.build_settings['SUPPORTED_PLATFORMS'] = 'iphoneos iphonesimulator appletvos appletvsimulator xros xrsimulator' # Highly suspect, commented out
       # config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2,3,7' # Highly suspect, commented out
     end

    target.build_configurations.each do |config|
        # Setting deployment targets per pod target can be useful,
        # but ensure they align with what each pod supports.
        # CocoaPods often infers this correctly from your main target's platform.
        current_platform_name = config.platform_name.to_s # Ensure it's a string for comparison
        if current_platform_name.start_with?('iphoneos') || current_platform_name.start_with?('iphonesimulator')
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        elsif current_platform_name.start_with?('appletvos') || current_platform_name.start_with?('appletvsimulator')
            config.build_settings['TVOS_DEPLOYMENT_TARGET'] = '12.0'
        elsif current_platform_name.start_with?('xros') || current_platform_name.start_with?('xrsimulator')
            # This would be for visionOS pods if not handled by the main target's platform setting
            config.build_settings['XROS_DEPLOYMENT_TARGET'] = '1.0' # Example, adjust if needed
        end

        # If you still need to force ARCHS for pod targets, do it conditionally:
        # if current_platform_name.include?("simulator")
        #   config.build_settings['ARCHS'] = 'arm64 x86_64'
        # else # Device builds (iphoneos, appletvos, xros)
        #   config.build_settings['ARCHS'] = 'arm64'
        # end
        # However, it's often best to let Xcode derive this from the active architecture being built.
        # The global ARCHS setting from the Pods project level (commented out above) was more problematic.

        # The sqlite fix
        xcconfig_path_obj = config.base_configuration_reference
        if xcconfig_path_obj # Ensure base_configuration_reference is not nil
            xcconfig_path = xcconfig_path_obj.real_path
            begin
                xcconfig = File.read(xcconfig_path)
                new_xcconfig = xcconfig.sub('-l"sqlite3"', '')
                File.open(xcconfig_path, "w") { |file| file << new_xcconfig }
            rescue Errno::ENOENT
                # Pods that don't have a base configuration (e.g. resource bundles)
                # won't have an xcconfig path, so we can ignore this error.
                # Or print a warning if you want to be notified:
                # puts "Warning: Could not find xcconfig at #{xcconfig_path} for target #{target.name}"
            end
        end
    end
  end
end