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
            Keys.alwaysPlayURLs: false,
            Keys.appThemeBlack: false,
            Keys.automaticallyPlayNextItem: true,
            Keys.brightnessGesture: true,
            Keys.castingAudioPassthrough: false,
            Keys.closeGesture: true,
            Keys.continueAudioInBackground: true,
            Keys.downloadArtwork: true,
            Keys.enableMediaCellTextScrolling: false,
            Keys.equalizerProfileDisabled: true,
            Keys.forceSMBV1: true,
            Keys.hideLibraryInFilesApp: false,
            Keys.networkRTSPTCP: false,
            Keys.passcodeEnableBiometricAuth: true,
            Keys.pauseWhenShowingControls: false,
            Keys.playbackForwardBackwardEqual: true,
            Keys.playbackLongTouchSpeedUp: true,
            Keys.playbackTapSwipeEqual: true,
            Keys.playerIsShuffleEnabled: false,
            Keys.playerShouldRememberBrightness: false,
            Keys.playerShouldRememberState: true,
            Keys.playerShowPlaybackSpeedShortcut: false,
            Keys.playlistPlayNextItem: true,
            Keys.playPauseGesture: true,
            Keys.restoreLastPlayedMedia: true,
            Keys.seekGesture: true,
            Keys.showRemainingTime: false,
            Keys.showThumbnails: true,
            Keys.stretchAudio: true,
            Keys.videoFullscreenPlayback: true,
            Keys.volumeGesture: true,

            // numbers
            Keys.continueAudioPlayback: 1,
            Keys.continuePlayback: 1,
            Keys.defaultPreampLevel: Float(6),

            // other
            Keys.hardwareDecoding: HardwareDecoding.hardware.rawValue,
            Keys.networkCaching: NetworkCaching.normal.rawValue,
            Keys.networkSatIPChannelListUrl: DefaultValues.networkSatIPChannelListUrl,
            Keys.playerIsRepeatEnabled: DefaultValues.playerRepeatMode,
            Keys.textEncoding: DefaultValues.textEncoding,
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

    @objc var alwaysPlayURLs: Bool {
        get {
            userDefaults.bool(forKey: Keys.alwaysPlayURLs)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.alwaysPlayURLs)
        }
    }

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

    @objc var brightnessGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.brightnessGesture)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.brightnessGesture)
        }
    }

    @objc var castingAudioPassthrough: Bool {
        get {
            userDefaults.bool(forKey: Keys.castingAudioPassthrough)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.castingAudioPassthrough)
        }
    }

    @objc var closeGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.closeGesture)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.closeGesture)
        }
    }

    @objc var downloadArtwork: Bool {
        get {
            userDefaults.bool(forKey: Keys.downloadArtwork)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.downloadArtwork)
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

    @objc var equalizerProfileDisabled: Bool {
        get {
            userDefaults.bool(forKey: Keys.equalizerProfileDisabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.equalizerProfileDisabled)
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

    @objc var networkRTSPTCP: Bool {
        get {
            userDefaults.bool(forKey: Keys.networkRTSPTCP)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.networkRTSPTCP)
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

    var playbackForwardBackwardEqual: Bool {
        get {
            userDefaults.bool(forKey: Keys.playbackForwardBackwardEqual)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playbackForwardBackwardEqual)
        }
    }

    @objc var playbackLongTouchSpeedUp: Bool {
        get {
            userDefaults.bool(forKey: Keys.playbackLongTouchSpeedUp)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playbackLongTouchSpeedUp)
        }
    }

    @objc var playbackTapSwipeEqual: Bool {
        get {
            userDefaults.bool(forKey: Keys.playbackTapSwipeEqual)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playbackTapSwipeEqual)
        }
    }

    @objc var playerIsShuffleEnabled: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerIsShuffleEnabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playerIsShuffleEnabled)
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

    @objc var playPauseGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.playPauseGesture)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playPauseGesture)
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

    @objc var seekGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.seekGesture)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.seekGesture)
        }
    }

    @objc var showArtworks: Bool {
        get {
            userDefaults.bool(forKey: Keys.showArtworks)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.showArtworks)
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

    @objc var showThumbnails: Bool {
        get {
            userDefaults.bool(forKey: Keys.showThumbnails)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.showThumbnails)
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

    @objc var videoFullscreenPlayback: Bool {
        get {
            userDefaults.bool(forKey: Keys.videoFullscreenPlayback)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.videoFullscreenPlayback)
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

    @objc var continueAudioPlayback: Int {
        get {
            userDefaults.integer(forKey: Keys.continueAudioPlayback)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.continueAudioPlayback)
        }
    }

    @objc var continuePlayback: Int {
        get {
            userDefaults.integer(forKey: Keys.continuePlayback)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.continuePlayback)
        }
    }

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

    @objc var networkSatIPChannelListUrl: String {
        get {
            userDefaults.string(forKey: Keys.networkSatIPChannelListUrl) ?? DefaultValues.networkSatIPChannelListUrl
        }
        set {
            userDefaults.set(newValue, forKey: Keys.networkSatIPChannelListUrl)
        }
    }

    @objc var playerIsRepeatEnabled: VLCRepeatMode {
        get {
            let v = userDefaults.integer(forKey: Keys.playerIsRepeatEnabled)
            return VLCRepeatMode(rawValue: v) ?? DefaultValues.playerRepeatMode
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playerIsRepeatEnabled)
        }
    }

    @objc var textEncoding: String {
        get {
            userDefaults.string(forKey: Keys.textEncoding) ?? DefaultValues.textEncoding
        }
        set {
            userDefaults.set(newValue, forKey: Keys.textEncoding)
        }
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
        static let continueAudioPlaybackKey: String = Keys.continueAudioPlayback
        static let continuePlaybackKey: String = Keys.continuePlayback
        static let defaultPreampLevelKey: String = Keys.defaultPreampLevel
        static let hardwareDecodingKey: String = Keys.hardwareDecoding
        static let hideLibraryInFilesAppKey: String = Keys.hideLibraryInFilesApp
        static let networkCachingKey: String = Keys.networkCaching
        static let textEncodingKey: String = Keys.textEncoding

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
    static let alwaysPlayURLs = "kVLCSettingAlwaysPlayURLs"
    static let appThemeBlack = "blackTheme"
    static let automaticallyPlayNextItem = "AutomaticallyPlayNextItem"
    static let brightnessGesture = "EnableBrightnessGesture"
    static let castingAudioPassthrough = "sout-chromecast-audio-passthrough"
    static let closeGesture = "EnableCloseGesture"
    static let continueAudioInBackground = "BackgroundAudioPlayback"
    static let continueAudioPlayback = "ContinueAudioPlayback"
    static let continuePlayback = "ContinuePlayback"
    static let defaultPreampLevel = "pre-amp-level"
    static let downloadArtwork = "download-artwork"
    static let enableMediaCellTextScrolling = "EnableMediaCellTextScrolling"
    static let equalizerProfileDisabled = "EqualizerDisabled"
    static let forceSMBV1 = "smb-force-v1"
    static let hardwareDecoding = "codec"
    static let hideLibraryInFilesApp = "HideLibraryInFilesApp"
    static let networkCaching = "network-caching"
    static let networkRTSPTCP = "rtsp-tcp"
    static let networkSatIPChannelListUrl = "satip-channellist-url"
    static let passcodeEnableBiometricAuth = "EnableBiometricAuth"
    static let pauseWhenShowingControls = "kVLCSettingPauseWhenShowingControls"
    static let playbackForwardBackwardEqual = "playback-forward-backward-equal"
    static let playbackLongTouchSpeedUp = "LongTouchSpeedUp"
    static let playbackTapSwipeEqual = "playback-tap-swipe-equal"
    static let playerIsRepeatEnabled = "PlayerIsRepeatEnabled"
    static let playerIsShuffleEnabled = "PlayerIsShuffleEnabled"
    static let playerShouldRememberBrightness = "PlayerShouldRememberBrightness"
    static let playerShouldRememberState = "PlayerShouldRememberState"
    static let playerShowPlaybackSpeedShortcut = "kVLCPlayerShowPlaybackSpeedShortcut"
    static let playlistPlayNextItem = "PlaylistPlayNextItem"
    static let playPauseGesture = "EnablePlayPauseGesture"
    static let restoreLastPlayedMedia = "RestoreLastPlayedMedia"
    static let seekGesture = "EnableSeekGesture"
    static let showArtworks = "ShowArtworks"
    static let showRemainingTime = "show-remaining-time"
    static let showThumbnails = "ShowThumbnails"
    static let stretchAudio = "audio-time-stretch"
    static let textEncoding = "subsdec-encoding"
    static let videoFullscreenPlayback = "AlwaysUseFullscreenForVideo"
    static let volumeGesture = "EnableVolumeGesture"

    static func videoLibraryGridLayout(collectionModelName: String? = nil, name: String) -> String {
        [
            "kVLCVideoLibraryGridLayout", collectionModelName, name
        ].compactMap { $0 }.joined()
    }
}

// MARK: - Default Values

fileprivate enum DefaultValues {
    static let textEncoding = "Windows-1252"
    static let networkSatIPChannelListUrl = ""
    static let playerRepeatMode = VLCRepeatMode.doNotRepeat
}
