/*****************************************************************************
 * SettingsSection.swift
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2020-2023 VideoLAN. All rights reserved.
 *
 * Authors: Swapnanil Dhol <swapnanildhol # gmail.com>
 *          Soomin Lee < bubu@mikan.io >
 *          Edgar Fouillet <vlc # edgar.fouillet.eu>
 *          Diogo Simao Marques <dogo@videolabs.io>
 *          Felix Paul Kühne <fkuehne # videolan.org>
 *          Eshan Singh <eeeshan789@icloud.com>
 *          Craig Reyenga <craig.reyenga # gmail.com>          
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import LocalAuthentication

// MARK: - SettingsItem

struct SettingsItem: Equatable {
    let title: String
    let subtitle: String?
    let action: Action
    let isTitleEmphasized: Bool

    @available(*, deprecated, message: "access from self.action")
    var preferenceKey: String? {
        switch action {
        case let .showActionSheet(_, preferenceKey, _):
            return preferenceKey
        default:
            return nil
        }
    }

    init(title: String, subtitle: String?, action: Action, isTitleEmphasized: Bool = false) {
        self.title = Localizer.localizedTitle(key: title)
        self.subtitle = subtitle.flatMap(Localizer.localizedTitle(key:))
        self.action = action
        self.isTitleEmphasized = isTitleEmphasized
    }

    static func toggle(title: String, subtitle: String? = nil, keyPath: WritableKeyPath<VLCDefaults, Bool>, onChange: ((Bool) -> Void)? = nil) -> Self {
        return Self(title: title, subtitle: subtitle, action: .toggle(Toggle(keyPath: keyPath, onChange: onChange)))
    }

    enum Action: Equatable {
        case isLoading
        case toggle(Toggle)
        case showActionSheet(title: String, preferenceKey: String, hasInfo: Bool)
        case donation
        case openPrivacySettings
        case forceRescanAlert
        case exportMediaLibrary
        case displayResetAlert
    }

    final class Toggle: Equatable {
        typealias Observer = (Bool) -> Void

        private let keyPath: WritableKeyPath<VLCDefaults, Bool>
        private let onChange: ((Bool) -> Void)?

        var isOn: Bool {
            VLCDefaults.shared[keyPath: keyPath]
        }

        private var observers: [Int: Observer] = [:]
        private var isNotifyingObservers: Bool = false
        private static let lock = NSLock()
        private static var _lastId: Int = 0
        private static var lastId: Int {
            get { lock.withLock { _lastId } }
            set { lock.withLock { _lastId = newValue } }
        }

        init(keyPath: WritableKeyPath<VLCDefaults, Bool>, onChange: ((Bool) -> Void)? = nil) {
            self.keyPath = keyPath
            self.onChange = onChange
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(defaultsDidUpdate),
                                                   name: .VLCDefaultsDidUpdate,
                                                   object: nil)
        }

        func set(isOn: Bool) {
            var defaults = VLCDefaults.shared
            defaults[keyPath: keyPath] = isOn
            onChange?(isOn)
        }

        // does not call out initially.
        func addObserver(_ observer: @escaping Observer) -> Int {
            let id = Self.lastId + 1
            Self.lastId = id
            observers[id] = observer
            return id
        }

        func removeObserver(_ Int: Int) {
            observers.removeValue(forKey: Int)
        }

        @objc private func defaultsDidUpdate(_: Notification) {
            notifyObservers()
        }

        private func notifyObservers() {
            precondition(!isNotifyingObservers, "updating the toggle switch from an observer is illegal")

            isNotifyingObservers = true

            // copy the keys so we can detect departures
            let keys = observers.keys
            for k in keys {
                // skip observers that have departed as we call out to each
                guard observers.keys.contains(k) else { continue }

                observers[k]!(isOn)
            }

            isNotifyingObservers = false
        }

        static func == (lhs: SettingsItem.Toggle, rhs: SettingsItem.Toggle) -> Bool {
            lhs.keyPath == rhs.keyPath
        }
    }
}

// MARK: - SettingsSection

struct SettingsSection: Equatable {
    let title: String?
    let items: [SettingsItem]

    var isEmpty: Bool {
        items.isEmpty
    }

    init(title: String? = nil, items: [SettingsItem]) {
        self.title = title.flatMap(Localizer.localizedTitle(key:))
        self.items = items
    }

    static func sections(mediaLibraryService: MediaLibraryService,
                         isLabActivated: Bool,
                         isBackingUp: Bool,
                         isForwardBackwardEqual: Bool,
                         isTapSwipeEqual: Bool) -> [SettingsSection] {
        [
            MainOptions.section(),
            DonationOptions.section(),
            GenericOptions.section(),
            PrivacyOptions.section(mediaLibraryService: mediaLibraryService),
            GestureControlOptions.section(isForwardBackwardEqual: isForwardBackwardEqual, isTapSwipeEqual: isTapSwipeEqual),
            VideoOptions.section(),
            SubtitlesOptions.section(),
            AudioOptions.section(),
            CastingOptions.section(),
            MediaLibraryOptions.section(mediaLibraryService: mediaLibraryService, isBackingUp: isBackingUp),
            NetworkOptions.section(),
            Accessibility.section(),
            Lab.section(isLabActivated: isLabActivated),
            Reset.section(),
        ].compactMap { $0 }
    }
}

// MARK: - MainOptions

enum MainOptions {
    static var privacy: SettingsItem {
        .init(title: "SETTINGS_PRIVACY_TITLE",
              subtitle: "SETTINGS_PRIVACY_SUBTITLE",
              action: .openPrivacySettings)
    }

    static var appearance: SettingsItem {
        let k = VLCDefaults.Compat.appThemeKey
        return .init(title: "SETTINGS_DARKTHEME",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_DARKTHEME", preferenceKey: k, hasInfo: false))
    }

    static func section() -> SettingsSection? {
        .init(title: nil, items: [
            privacy,
            appearance,
        ])
    }
}

// MARK: - DonationOptions

enum DonationOptions {
    static var donate: SettingsItem {
        .init(title: "SETTINGS_DONATE",
              subtitle: "SETTINGS_DONATE_LONG",
              action: .donation)
    }

    static func section() -> SettingsSection? {
        .init(title: "SETTINGS_DONATE_TITLE", items: [donate])
    }
}

// MARK: - GenericOptions

enum GenericOptions {
    static var defaultPlaybackSpeed: SettingsItem {
        let k = VLCDefaults.Compat.playbackSpeedDefaultValueKey
        return .init(title: "SETTINGS_PLAYBACK_SPEED_DEFAULT",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_PLAYBACK_SPEED_DEFAULT", preferenceKey: k, hasInfo: false))
    }

    static var continueAudioPlayback: SettingsItem {
        let k = VLCDefaults.Compat.continueAudioPlaybackKey
        return .init(title: "SETTINGS_CONTINUE_AUDIO_PLAYBACK",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_CONTINUE_AUDIO_PLAYBACK", preferenceKey: k, hasInfo: true))
    }

    static var playVideoInFullScreen: SettingsItem {
        .toggle(title: "SETTINGS_VIDEO_FULLSCREEN",
                keyPath: \.videoFullscreenPlayback)
    }

    static var continueVideoPlayback: SettingsItem {
        let k = VLCDefaults.Compat.continuePlaybackKey
        return .init(title: "SETTINGS_CONTINUE_VIDEO_PLAYBACK",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_CONTINUE_VIDEO_PLAYBACK", preferenceKey: k, hasInfo: true))
    }

    static var automaticallyPlayNextItem: SettingsItem {
        let k = VLCDefaults.Compat.automaticallyPlayNextItemKey
        return .init(title: "SETTINGS_NETWORK_PLAY_ALL",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_NETWORK_PLAY_ALL", preferenceKey: k, hasInfo: false))
    }

    static var enableTextScrollingInMediaList: SettingsItem {
        .toggle(title: "SETTINGS_ENABLE_MEDIA_CELL_TEXT_SCROLLING",
                keyPath: \.enableMediaCellTextScrolling)
    }

    static var rememberPlayerState: SettingsItem {
        .toggle(title: "SETTINGS_REMEMBER_PLAYER_STATE",
                keyPath: \.playerShouldRememberState)
    }

    static var restoreLastPlayedMedia: SettingsItem {
        .toggle(title: "SETTINGS_RESTORE_LAST_PLAYED_MEDIA",
                keyPath: \.restoreLastPlayedMedia)
    }

    static func section() -> SettingsSection? {
        .init(title: "SETTINGS_GENERIC_TITLE", items: [
            defaultPlaybackSpeed,
            continueAudioPlayback,
            playVideoInFullScreen,
            continueVideoPlayback,
            automaticallyPlayNextItem,
            enableTextScrollingInMediaList,
            rememberPlayerState,
            restoreLastPlayedMedia,
        ])
    }
}

// MARK: - PrivacyOptions

enum PrivacyOptions {
    static var passcodeLock: SettingsItem {
        .toggle(title: "SETTINGS_PASSCODE_LOCK",
                subtitle: "SETTINGS_PASSCODE_LOCK_SUBTITLE",
                keyPath: \.passcodeOn) { isOn in
            if isOn {
                KeychainCoordinator.passcodeService.setSecret { success in
                    // If the user cancels setting the password, the toggle should revert to the unset state.
                    // This ensures the UI reflects the correct state.
                    VLCDefaults.shared.passcodeOn = success
                    NotificationCenter.default.post(name: .VLCSettingsShouldReloadNotification, object: nil) // To show/hide biometric row
                }
            } else {
                // When disabled any existing passcode should be removed.
                // If user previously set a passcode and then disable and enable it
                // the new passcode view will be showed, but if user terminates the app
                // passcode will remain open even if the user doesn't set the new passcode.
                // So, this may cause the app being locked.
                try? KeychainCoordinator.passcodeService.removeSecret()

                NotificationCenter.default.post(name: .VLCSettingsShouldReloadNotification, object: nil)
            }
        }
    }

    static var enableBiometrics: SettingsItem? {
        let authContext = LAContext()

        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch authContext.biometryType {
            case .touchID:
                return .toggle(title: "SETTINGS_PASSCODE_LOCK_ALLOWTOUCHID",
                               keyPath: \.passcodeEnableBiometricAuth)
            case .faceID:
                return .toggle(title: "SETTINGS_PASSCODE_LOCK_ALLOWFACEID",
                               keyPath: \.passcodeEnableBiometricAuth)
            case .opticID:
                return .toggle(title: "SETTINGS_PASSCODE_LOCK_ALLOWOPTICID",
                               keyPath: \.passcodeEnableBiometricAuth)
            case .none:
                fallthrough
            @unknown default:
                return nil
            }
        }

        return nil
    }

    static func hideLibraryInFilesApp(mediaLibraryService: MediaLibraryService) -> SettingsItem {
        .toggle(title: "SETTINGS_HIDE_LIBRARY_IN_FILES_APP",
                subtitle: "SETTINGS_HIDE_LIBRARY_IN_FILES_APP_SUBTITLE",
                keyPath: \.hideLibraryInFilesApp) { isOn in
            mediaLibraryService.hideMediaLibrary(isOn)
        }
    }

    static func section(mediaLibraryService: MediaLibraryService) -> SettingsSection? {
        .init(title: "SETTINGS_PRIVACY_TITLE", items: [
            passcodeLock,
            enableBiometrics,
            hideLibraryInFilesApp(mediaLibraryService: mediaLibraryService),
        ].compactMap { $0 })
    }
}

// MARK: - GestureControlOptions

enum GestureControlOptions {
    static var swipeUpDownForVolume: SettingsItem {
        .toggle(title: "SETTINGS_GESTURES_VOLUME",
                keyPath: \.volumeGesture)
    }

    static var twoFingerTap: SettingsItem {
        .toggle(title: "SETTINGS_GESTURES_PLAYPAUSE",
                keyPath: \.playPauseGesture)
    }

    static var swipeUpDownForBrightness: SettingsItem {
        .toggle(title: "SETTINGS_GESTURES_BRIGHTNESS",
                keyPath: \.brightnessGesture)
    }

    static var swipeRightLeftToSeek: SettingsItem {
        .toggle(title: "SETTINGS_GESTURES_SEEK",
                keyPath: \.seekGesture)
    }

    static var pinchToClose: SettingsItem {
        .toggle(title: "SETTINGS_GESTURES_CLOSE",
                keyPath: \.closeGesture)
    }

    static var forwardBackwardEqual: SettingsItem {
        .toggle(title: "SETTINGS_GESTURES_FORWARD_BACKWARD_EQUAL",
                keyPath: \.playbackForwardBackwardEqual)
    }

    static var tapSwipeEqual: SettingsItem {
        .toggle(title: "SETTINGS_GESTURES_TAP_SWIPE_EQUAL",
                keyPath: \.playbackTapSwipeEqual)
    }

    static var forwardSkipLength: SettingsItem {
        let k = VLCDefaults.Compat.playbackForwardSkipLengthKey
        return .init(title: dynamicForwardSkipDescription(),
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: dynamicForwardSkipDescription(), preferenceKey: k, hasInfo: false))
    }

    static var backwardSkipLength: SettingsItem {
        let k = VLCDefaults.Compat.playbackBackwardSkipLengthKey
        return .init(title: dynamicBackwardSkipDescription(),
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: dynamicBackwardSkipDescription(), preferenceKey: k, hasInfo: false))
    }

    static var forwardSkipLengthSwipe: SettingsItem {
        let k = VLCDefaults.Compat.playbackForwardSkipLengthSwipeKey
        return .init(title: dynamicForwardSwipeDescription(),
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: dynamicForwardSwipeDescription(), preferenceKey: k, hasInfo: false))
    }

    static var backwardSkipLengthSwipe: SettingsItem {
        let k = VLCDefaults.Compat.playbackBackwardSkipLengthSwipeKey
        return .init(title: "SETTINGS_PLAYBACK_SKIP_BACKWARD_SWIPE",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_PLAYBACK_SKIP_BACKWARD_SWIPE", preferenceKey: k, hasInfo: false))
    }

    static var longTouchToSpeedUp: SettingsItem {
        .toggle(title: "SETINGS_LONG_TOUCH_SPEED_UP",
                keyPath: \.playbackLongTouchSpeedUp)
    }

    static var lockScreenSkip: SettingsItem {
        let k = VLCDefaults.Compat.lockscreenSkipKey
        return .init(title: "SETTINGS_PLAYBACK_LOCKSCREEN_SKIP",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_PLAYBACK_LOCKSCREEN_SKIP", preferenceKey: k, hasInfo: false))
    }

    static var externalControlsSkip: SettingsItem {
        let k = VLCDefaults.Compat.remoteControlSkipKey
        return .init(title: "SETTINGS_PLAYBACK_EXTERNAL_CONTROLS_SKIP",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_PLAYBACK_EXTERNAL_CONTROLS_SKIP", preferenceKey: k, hasInfo: false))
    }

    static func section(isForwardBackwardEqual: Bool, isTapSwipeEqual: Bool) -> SettingsSection? {
        .init(title: "SETTINGS_GESTURES", items: [
            swipeUpDownForVolume,
            twoFingerTap,
            swipeUpDownForBrightness,
            swipeRightLeftToSeek,
            pinchToClose,
            forwardBackwardEqual,
            tapSwipeEqual,
            forwardSkipLength,
            isForwardBackwardEqual ? nil : backwardSkipLength,
            isTapSwipeEqual ? nil : forwardSkipLengthSwipe,
            (isTapSwipeEqual || isForwardBackwardEqual) ? nil : backwardSkipLengthSwipe,
            longTouchToSpeedUp,
            lockScreenSkip,
            externalControlsSkip,
        ].compactMap { $0 })
    }

    private static func dynamicForwardSkipDescription() -> String {
        let forwardBackwardEqual = VLCDefaults.shared.playbackForwardBackwardEqual
        let tapSwipeEqual = VLCDefaults.shared.playbackTapSwipeEqual

        if forwardBackwardEqual && tapSwipeEqual {
            return "SETTINGS_PLAYBACK_SKIP_GENERIC"
        } else if forwardBackwardEqual && !tapSwipeEqual {
            return "SETTINGS_PLAYBACK_SKIP_TAP"
        } else if !forwardBackwardEqual && !tapSwipeEqual {
            return "SETTINGS_PLAYBACK_SKIP_FORWARD_TAP"
        } else {
            return "SETTINGS_PLAYBACK_SKIP_FORWARD"
        }
    }

    private static func dynamicBackwardSkipDescription() -> String {
        let tapSwipeEqual = VLCDefaults.shared.playbackTapSwipeEqual

        if tapSwipeEqual {
            return "SETTINGS_PLAYBACK_SKIP_BACKWARD"
        } else {
            return "SETTINGS_PLAYBACK_SKIP_BACKWARD_TAP"
        }
    }

    private static func dynamicForwardSwipeDescription() -> String {
        let forwardBackwardEqual = VLCDefaults.shared.playbackForwardBackwardEqual

        if forwardBackwardEqual {
            return "SETTINGS_PLAYBACK_SKIP_SWIPE"
        } else {
            return "SETTINGS_PLAYBACK_SKIP_FORWARD_SWIPE"
        }
    }
}

// MARK: - VideoOptions

enum VideoOptions {
    static var deBlockingFilter: SettingsItem {
        let k = VLCDefaults.Compat.skipLoopFilterKey
        return .init(title: "SETTINGS_SKIP_LOOP_FILTER",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_SKIP_LOOP_FILTER", preferenceKey: k, hasInfo: true))
    }

    static var deInterlace: SettingsItem {
        let k = VLCDefaults.Compat.deinterlaceKey
        return .init(title: "SETTINGS_DEINTERLACE",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_DEINTERLACE", preferenceKey: k, hasInfo: true))
    }

    static var hardwareDecoding: SettingsItem {
        let k = VLCDefaults.Compat.hardwareDecodingKey
        return .init(title: "SETTINGS_HWDECODING",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_HWDECODING", preferenceKey: k, hasInfo: true))
    }

    static var rememberPlayerBrightness: SettingsItem {
        .toggle(title: "SETTINGS_REMEMBER_PLAYER_BRIGHTNESS",
                keyPath: \.playerShouldRememberBrightness)
    }

    static var lockRotation: SettingsItem {
        .toggle(title: "SETTINGS_LOCK_ROTATION",
                keyPath: \.rotationLock)
    }

    static func section() -> SettingsSection? {
        var options = [deBlockingFilter, deInterlace, hardwareDecoding, rememberPlayerBrightness]

        if UIDevice.current.userInterfaceIdiom == .phone {
            options.append(lockRotation)
        }

        return .init(title: "SETTINGS_VIDEO_TITLE", items: options)
    }
}

// MARK: - SubtitlesOptions

enum SubtitlesOptions {
    static var disableSubtitles: SettingsItem {
        .toggle(title: "SETTINGS_SUBTITLES_DISABLE",
                subtitle: "SETTINGS_SUBTITLES_DISABLE_LONG",
                keyPath: \.disableSubtitles)
    }

    static var font: SettingsItem {
        let k = VLCDefaults.Compat.subtitlesFontKey
        return .init(title: "SETTINGS_SUBTITLES_FONT",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_SUBTITLES_FONT", preferenceKey: k, hasInfo: true))
    }

    static var relativeFontSize: SettingsItem {
        let k = VLCDefaults.Compat.subtitlesFontSizeKey
        return .init(title: "SETTINGS_SUBTITLES_FONTSIZE",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_SUBTITLES_FONTSIZE", preferenceKey: k, hasInfo: true))
    }

    static var useBoldFont: SettingsItem {
        .toggle(title: "SETTINGS_SUBTITLES_BOLDFONT",
                keyPath: \.subtitlesBoldFont)
    }

    static var fontColor: SettingsItem {
        let k = VLCDefaults.Compat.subtitlesFontColorKey
        return .init(title: "SETTINGS_SUBTITLES_FONTCOLOR",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_SUBTITLES_FONTCOLOR", preferenceKey: k, hasInfo: true))
    }

    static var textEncoding: SettingsItem {
        let k = VLCDefaults.Compat.textEncodingKey
        return .init(title: "SETTINGS_SUBTITLES_TEXT_ENCODING",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_SUBTITLES_TEXT_ENCODING", preferenceKey: k, hasInfo: true))
    }

    static func section() -> SettingsSection? {
        .init(title: "SETTINGS_SUBTITLES_TITLE", items: [
            disableSubtitles,
            font,
            relativeFontSize,
            useBoldFont,
            fontColor,
            textEncoding,
        ])
    }
}

// MARK: - CastingOptions

enum CastingOptions {
    static var audioPassThrough: SettingsItem {
        .toggle(title: "SETTINGS_PTCASTING",
                subtitle: "SETTINGS_PTCASTINGLONG",
                keyPath: \.castingAudioPassthrough)
    }

    static var conversionQuality: SettingsItem {
        let k = VLCDefaults.Compat.castingConversionQualityKey
        return .init(title: "SETTINGS_CASTING_CONVERSION_QUALITY",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_CASTING_CONVERSION_QUALITY", preferenceKey: k, hasInfo: false))
    }

    static func section() -> SettingsSection? {
        .init(title: "SETTINGS_CASTING", items: [
            audioPassThrough,
            conversionQuality,
        ])
    }
}

// MARK: - AudioOptions

enum AudioOptions {
    static var preampLevel: SettingsItem {
        let k = VLCDefaults.Compat.defaultPreampLevelKey
        return .init(title: "SETTINGS_AUDIO_PREAMP_LEVEL",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_AUDIO_PREAMP_LEVEL", preferenceKey: k, hasInfo: false))
    }

    static var timeStretchingAudio: SettingsItem {
        .toggle(title: "SETTINGS_TIME_STRETCH_AUDIO",
                subtitle: "SETTINGS_TIME_STRETCH_AUDIO_LONG",
                keyPath: \.stretchAudio)
    }

    static var audioPlaybackInBackground: SettingsItem {
        .toggle(title: "SETTINGS_BACKGROUND_AUDIO",
                keyPath: \.continueAudioInBackgroundKey)
    }

    static func section() -> SettingsSection? {
        .init(title: "SETTINGS_AUDIO_TITLE", items: [
            preampLevel,
            timeStretchingAudio,
            audioPlaybackInBackground,
        ])
    }
}

// MARK: - MediaLibraryOptions

enum MediaLibraryOptions {
    static var forceVLCToRescanTheMediaLibrary: SettingsItem {
        .init(title: "SETTINGS_MEDIA_LIBRARY_RESCAN",
              subtitle: nil,
              action: .forceRescanAlert,
              isTitleEmphasized: true)
    }

    static var optimiseItemNamesForDisplay: SettingsItem {
        .toggle(title: "SETTINGS_DECRAPIFY",
                keyPath: \.optimizeTitles)
    }

    static var disableGrouping: SettingsItem {
        .toggle(title: "SETTINGS_DISABLE_GROUPING",
                keyPath: \.disableGrouping) { isOn in
            NotificationCenter.default.post(name: .VLCDisableGroupingDidChangeNotification, object: nil)
        }
    }

    static var showVideoThumbnails: SettingsItem {
        .toggle(title: "SETTINGS_SHOW_THUMBNAILS",
                keyPath: \.showThumbnails)
    }

    static var showAudioArtworks: SettingsItem {
        .toggle(title: "SETTINGS_SHOW_ARTWORKS",
                keyPath: \.showArtworks)
    }

    static func includeMediaLibInDeviceBackup(mediaLibraryService: MediaLibraryService) -> SettingsItem {
        .toggle(title: "SETTINGS_BACKUP_MEDIA_LIBRARY",
                keyPath: \.backupMediaLibrary) { isOn in
            mediaLibraryService.excludeFromDeviceBackup(isOn)
        }
    }

    static var includeMediaLibInDeviceBackupWhenBackingUp: SettingsItem {
        .init(title: "SETTINGS_BACKUP_MEDIA_LIBRARY",
              subtitle: nil,
              action: .isLoading)
    }

    static func section(mediaLibraryService: MediaLibraryService, isBackingUp: Bool) -> SettingsSection? {
        var options = [forceVLCToRescanTheMediaLibrary,
                       optimiseItemNamesForDisplay,
                       disableGrouping,
                       showVideoThumbnails,
                       showAudioArtworks]

        if isBackingUp {
            options.append(includeMediaLibInDeviceBackupWhenBackingUp)
        } else {
            options.append(includeMediaLibInDeviceBackup(mediaLibraryService: mediaLibraryService))
        }

        return .init(title: "SETTINGS_MEDIA_LIBRARY", items: options)
    }
}

// MARK: - NetworkOptions

enum NetworkOptions {
    static var networkCachingLevel: SettingsItem {
        let k = VLCDefaults.Compat.networkCachingKey
        return .init(title: "SETTINGS_NETWORK_CACHING_TITLE",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_NETWORK_CACHING_TITLE", preferenceKey: k, hasInfo: true))
    }

    static var ipv6SupportForWiFiSharing: SettingsItem {
        .toggle(title: "SETTINGS_WIFISHARING_IPv6",
                keyPath: \.wifiSharingIPv6)
    }

    static var forceSMBv1: SettingsItem {
        .toggle(title: "SETTINGS_FORCE_SMBV1",
                subtitle: "SETTINGS_FORCE_SMBV1_LONG",
                keyPath: \.forceSMBV1)
    }

    static var rtspctp: SettingsItem {
        .toggle(title: "SETTINGS_RTSP_TCP",
                keyPath: \.networkRTSPTCP)
    }

    static func section() -> SettingsSection? {
        .init(title: "SETTINGS_NETWORK", items: [
            networkCachingLevel,
            ipv6SupportForWiFiSharing,
            forceSMBv1,
            rtspctp,
        ])
    }
}

// MARK: - Accessibility

enum Accessibility {
    static var playerControlDuration: SettingsItem {
        let k = VLCDefaults.Compat.playerControlDurationKey
        return .init(title: "SETTINGS_PLAYER_CONTROL_DURATION",
                     subtitle: Localizer.getSubtitle(for: k),
                     action: .showActionSheet(title: "SETTINGS_PLAYER_CONTROL_DURATION", preferenceKey: k, hasInfo: false))
    }

    static var pauseWhenShowingControls: SettingsItem {
        .toggle(title: "SETTINGS_PAUSE_WHEN_SHOWING_CONTROLS",
                keyPath: \.pauseWhenShowingControls)
    }

    static func section() -> SettingsSection? {
        .init(title: "SETTINGS_ACCESSIBILITY", items: [
            playerControlDuration,
            pauseWhenShowingControls
        ])
    }
}

// MARK: - Lab

enum Lab {
    static var debugLogging: SettingsItem {
        .toggle(title: "SETTINGS_DEBUG_LOG",
                keyPath: \.saveDebugLogs)
    }

    static var exportLibrary: SettingsItem {
        .init(title: "SETTINGS_EXPORT_LIBRARY",
              subtitle: nil,
              action: .exportMediaLibrary)
    }

    static func section(isLabActivated: Bool) -> SettingsSection? {
        guard isLabActivated else { return nil }

        return .init(title: "SETTINGS_LAB", items: [
            debugLogging,
            exportLibrary,
        ])
    }
}

// MARK: - Reset

enum Reset {
    static var resetOptions: SettingsItem {
        .init(title: "SETTINGS_RESET",
              subtitle: nil,
              action: .displayResetAlert)
    }

    static func section() -> SettingsSection? {
        .init(title: "SETTINGS_RESET_TITLE",
              items: [resetOptions])
    }
}

// MARK: - Private

private enum Localizer {
    private static let localizer = NSObject()
    private static let settingsBundle = localizer.getSettingsBundle()!

    static func localizedTitle(key: String) -> String {
        settingsBundle.localizedString(forKey: key, value: key, table: "Root")
    }

    static func getSubtitle(for preferenceKey: String) -> String? {
        localizer.getSubtitle(for: preferenceKey)
    }
}
