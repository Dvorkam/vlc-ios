/*****************************************************************************
 * VLCDefaults.swift
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2025 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Craig Reyenga <craig.reyenga # gmail.com>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

@objc final class VLCDefaults: NSObject {
    @objc static let shared = VLCDefaults()

    private let userDefaults = UserDefaults.standard

    private override init() {}

    @objc func registerDefaults() {
        var dict: [String: Any] = [
            // bools
            Keys.appThemeBlack: false,
            Keys.automaticallyPlayNextItem: true,
            Keys.continueAudioInBackground: true,
            Keys.enableMediaCellTextScrolling: false,
            Keys.forceSMBV1: true,
            Keys.hideLibraryInFilesApp: false,
            Keys.passcodeEnableBiometricAuth: true,
            Keys.pauseWhenShowingControls: false,
            Keys.playerShouldRememberBrightness: false,
            Keys.playerShouldRememberState: true,
            Keys.playerShowPlaybackSpeedShortcut: false,
            Keys.playlistPlayNextItem: true,
            Keys.restoreLastPlayedMedia: true,
            Keys.showRemainingTime: false,
            Keys.stretchAudio: true,
            Keys.volumeGesture: true,

            // numbers
            Keys.defaultPreampLevel: Float(6),

            // other
            Keys.hardwareDecoding: HardwareDecoding.hardware.rawValue,
            Keys.networkCaching: NetworkCaching.normal.rawValue,
        ]

        [
            "ALBUMS",
            "ARTISTS",
            "GENRES",
            "ALL_VIDEOS",
            "VIDEO_GROUPS",
            "VLCMLMediaGroupCollections"
        ].forEach { s in
            dict[Keys.videoLibraryGridLayout(name: s)] = true
        }

        userDefaults.register(defaults: dict)
    }
}

// MARK: - Defaults

extension VLCDefaults {

    // Bools

    @objc var appThemeBlack: Bool {
        get {
            userDefaults.bool(forKey: Keys.appThemeBlack)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.appThemeBlack)
        }
    }

    @objc var automaticallyPlayNextItem: Bool {
        get {
            userDefaults.bool(forKey: Keys.automaticallyPlayNextItem)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.automaticallyPlayNextItem)
        }
    }

    @objc var continueAudioInBackgroundKey: Bool {
        get {
            userDefaults.bool(forKey: Keys.continueAudioInBackground)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.continueAudioInBackground)
        }
    }

    @objc var enableMediaCellTextScrolling: Bool {
        get {
            userDefaults.bool(forKey: Keys.enableMediaCellTextScrolling)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.enableMediaCellTextScrolling)
        }
    }

    @objc var forceSMBV1: Bool {
        get {
            userDefaults.bool(forKey: Keys.forceSMBV1)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.forceSMBV1)
        }
    }

    @objc var hideLibraryInFilesApp: Bool {
        get {
            userDefaults.bool(forKey: Keys.hideLibraryInFilesApp)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.hideLibraryInFilesApp)
        }
    }

    @objc var pauseWhenShowingControls: Bool {
        get {
            userDefaults.bool(forKey: Keys.pauseWhenShowingControls)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.pauseWhenShowingControls)
        }
    }

    @objc var playerShouldRememberBrightness: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerShouldRememberBrightness)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playerShouldRememberBrightness)
        }
    }

    @objc var playerShouldRememberState: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerShouldRememberState)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playerShouldRememberState)
        }
    }

    @objc var passcodeEnableBiometricAuth: Bool {
        get {
            userDefaults.bool(forKey: Keys.passcodeEnableBiometricAuth)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.passcodeEnableBiometricAuth)
        }
    }

    @objc var playerShowPlaybackSpeedShortcut: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerShowPlaybackSpeedShortcut)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playerShowPlaybackSpeedShortcut)
        }
    }

    @objc var playlistPlayNextItem: Bool {
        get {
            userDefaults.bool(forKey: Keys.playlistPlayNextItem)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playlistPlayNextItem)
        }
    }

    @objc var restoreLastPlayedMedia: Bool {
        get {
            userDefaults.bool(forKey: Keys.restoreLastPlayedMedia)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.restoreLastPlayedMedia)
        }
    }

    @objc var showRemainingTime: Bool {
        get {
            userDefaults.bool(forKey: Keys.showRemainingTime)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.showRemainingTime)
        }
    }

    @objc var stretchAudio: Bool {
        get {
            userDefaults.bool(forKey: Keys.stretchAudio)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.stretchAudio)
        }
    }

    @objc var volumeGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.volumeGesture)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.volumeGesture)
        }
    }

    // Numbers

    @objc var defaultPreampLevel: Float {
        get {
            userDefaults.float(forKey: Keys.defaultPreampLevel)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.defaultPreampLevel)
        }
    }

    // Other

    var hardwareDecoding: HardwareDecoding {
        get {
            guard let v = userDefaults.string(forKey: Keys.hardwareDecoding) else {
                return HardwareDecoding.hardware
            }

            return HardwareDecoding(rawValue: v) ?? .hardware
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.hardwareDecoding)
        }
    }

    @objc var hardwareDecodingObjC: String {
        hardwareDecoding.rawValue
    }

    var networkCaching: NetworkCaching {
        get {
            let v = userDefaults.integer(forKey: Keys.networkCaching)
            return NetworkCaching(rawValue: v) ?? .normal
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.networkCaching)
        }
    }

    @objc var networkCachingObjC: Int {
        networkCaching.rawValue
    }

    func videoLibraryGridLayout(collectionModelName: String? = nil, name: String) -> Bool {
        userDefaults.bool(forKey: Keys.videoLibraryGridLayout(collectionModelName: collectionModelName, name: name))
    }

    func setVideoLibraryGridLayout(collectionModelName: String? = nil, name: String, isGrid: Bool) {
        userDefaults.set(isGrid, forKey: Keys.videoLibraryGridLayout(collectionModelName: collectionModelName, name: name))
    }
}

// MARK: - Compatibility

extension VLCDefaults {
    @available(*, deprecated, message: "avoid using keys to access defaults directly, instead use properties on VLCDefaults")
    @objc(VLCDefaultsCompat)
    final class Compat: NSObject {
        static let automaticallyPlayNextItemKey: String = Keys.automaticallyPlayNextItem
        static let defaultPreampLevelKey: String = Keys.defaultPreampLevel
        @objc static let hardwareDecodingKey: String = Keys.hardwareDecoding
        static let hideLibraryInFilesAppKey: String = Keys.hideLibraryInFilesApp
        @objc static let networkCachingKey: String = Keys.networkCaching
        @objc static let stretchAudioKey: String = Keys.stretchAudio

        override init() {
            fatalError("compat struct not intended to be instantiated")
        }
    }
}

// MARK: - Value Types

extension VLCDefaults {
    enum HardwareDecoding: String {
        case software = "avcodec,all"
        case hardware = ""
    }
}

extension VLCDefaults {
    enum NetworkCaching: Int {
        case lowest = 333
        case low = 666
        case normal = 999
        case high = 1667
        case highest = 3333
    }
}

// MARK: - Keys

fileprivate enum Keys {
    // Avoid ever changing these values. Some are used as parameters in functions.
    // Changing a value also causes the locally stored value to become unreachable.
    static let appThemeBlack = "blackTheme"
    static let automaticallyPlayNextItem = "AutomaticallyPlayNextItem"
    static let continueAudioInBackground = "BackgroundAudioPlayback"
    static let defaultPreampLevel = "pre-amp-level"
    static let enableMediaCellTextScrolling = "EnableMediaCellTextScrolling"
    static let forceSMBV1 = "smb-force-v1"
    static let hardwareDecoding = "codec"
    static let hideLibraryInFilesApp = "HideLibraryInFilesApp"
    static let networkCaching = "network-caching"
    static let passcodeEnableBiometricAuth = "EnableBiometricAuth"
    static let pauseWhenShowingControls = "kVLCSettingPauseWhenShowingControls"
    static let playerShouldRememberBrightness = "PlayerShouldRememberBrightness"
    static let playerShouldRememberState = "PlayerShouldRememberState"
    static let playerShowPlaybackSpeedShortcut = "kVLCPlayerShowPlaybackSpeedShortcut"
    static let playlistPlayNextItem = "PlaylistPlayNextItem"
    static let restoreLastPlayedMedia = "RestoreLastPlayedMedia"
    static let showRemainingTime = "show-remaining-time"
    static let stretchAudio = "audio-time-stretch"
    static let volumeGesture = "EnableVolumeGesture"

    static func videoLibraryGridLayout(collectionModelName: String? = nil, name: String) -> String {
        [
            "kVLCVideoLibraryGridLayout", collectionModelName, name
        ].compactMap { $0 }.joined()
    }
}
