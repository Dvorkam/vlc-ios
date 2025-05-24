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
  installer_representation.pods_project.targets.each do |pod_target| # This 'pod_target' is a PBXNativeTarget
     # This loop iterates over build configurations of the Pods PROJECT (Debug, Release)
     # Settings here are inherited by all pod targets unless overridden.
     installer_representation.pods_project.build_configurations.each do |proj_config|
       proj_config.build_settings['SKIP_INSTALL'] = 'YES'
       proj_config.build_settings['CLANG_CXX_LIBRARY'] = 'libc++'
       # Keep these commented out unless absolutely necessary and well-understood,
       # as they were prime suspects for the original module not found issue.
       # proj_config.build_settings['ARCHS'] = 'arm64 x86_64'
       # proj_config.build_settings['SUPPORTED_PLATFORMS'] = 'iphoneos iphonesimulator appletvos appletvsimulator xros xrsimulator'
       # proj_config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2,3,7'
     end

    # Get the platform name from the pod_target itself (e.g., :ios, :tvos, :visionos)
    # This 'pod_target' is the individual pod target (e.g., Alamofire, MarqueeLabel-iOS)
    actual_pod_target_platform_name = pod_target.platform_name.to_s # Converts symbol :ios to string "ios"

    # This loop iterates over each build configuration (e.g., Debug, Release) of the current pod_target
    pod_target.build_configurations.each do |target_config| # 'target_config' is an XCBuildConfiguration
        # Set deployment targets based on the pod_target's platform
        if actual_pod_target_platform_name == 'ios'
            target_config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        elsif actual_pod_target_platform_name == 'tvos'
            target_config.build_settings['TVOS_DEPLOYMENT_TARGET'] = '12.0'
        elsif actual_pod_target_platform_name == 'visionos' # 'xros' is often used internally by Xcode for visionOS
            target_config.build_settings['XROS_DEPLOYMENT_TARGET'] = '1.0'
        end

        # The sqlite fix
        xcconfig_path_obj = target_config.base_configuration_reference
        if xcconfig_path_obj # Ensure base_configuration_reference is not nil
            xcconfig_path = xcconfig_path_obj.real_path
            begin
                if File.exist?(xcconfig_path) # Check if file actually exists
                    xcconfig_content = File.read(xcconfig_path)
                    # Only rewrite if changed to avoid unnecessary modifications
                    if xcconfig_content.include?('-l"sqlite3"')
                        new_xcconfig_content = xcconfig_content.sub('-l"sqlite3"', '')
                        File.open(xcconfig_path, "w") { |file| file << new_xcconfig_content }
                    end
                # else
                #   puts "INFO: xcconfig file not found at #{xcconfig_path} for target #{pod_target.name}, config #{target_config.name} (skipping sqlite fix)"
                end
            rescue Errno::ENOENT
                # This rescue might be redundant if File.exist? is used, but kept for safety.
                # puts "WARNING: Could not access xcconfig at #{xcconfig_path} (ENOENT)"
            # rescue => e # Catch other potential errors
                # puts "WARNING: Error processing xcconfig for #{pod_target.name} (#{target_config.name}): #{e.message}"
            end
        end
    end
  end
end