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
            Keys.audioLibraryHideFeatArtists: false,
            Keys.automaticallyPlayNextItem: true,
            Keys.backupMediaLibrary: false,
            Keys.brightnessGesture: true,
            Keys.castingAudioPassthrough: false,
            Keys.closeGesture: true,
            Keys.continueAudioInBackground: true,
            Keys.currentlyPlayingPlaylist: false,
            Keys.downloadArtwork: true,
            Keys.enableMediaCellTextScrolling: false,
            Keys.equalizerProfileDisabled: true,
            Keys.forceSMBV1: true,
            Keys.hideLibraryInFilesApp: false,
            Keys.mediaLibraryServiceDidForceRescan: false,
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
            Keys.playerUIShouldHide: false,
            Keys.playlistPlayNextItem: true,
            Keys.playPauseGesture: true,
            Keys.restoreLastPlayedMedia: true,
            Keys.seekGesture: true,
            Keys.showRemainingTime: false,
            Keys.showThumbnails: true,
            Keys.stretchAudio: true,
            Keys.subtitlesBoldFont: false,
            Keys.videoFullscreenPlayback: true,
            Keys.volumeGesture: true,
            Keys.wifiSharingIPv6: false,

            // numbers
            Keys.castingConversionQuality: DefaultValues.castingConversionQuality,
            Keys.continueAudioPlayback: 1,
            Keys.continuePlayback: 1,
            Keys.defaultPreampLevel: Float(6),
            Keys.deinterlace: DefaultValues.deinterlace,
            Keys.equalizerProfile: DefaultValues.equalizerProfile,
            Keys.playbackBackwardSkipLength: DefaultValues.playbackBackwardSkipLength,
            Keys.playbackBackwardSkipLengthSwipe: DefaultValues.playbackBackwardSkipLengthSwipe,
            Keys.playbackForwardSkipLength: DefaultValues.playbackForwardSkipLength,
            Keys.playbackForwardSkipLengthSwipe: DefaultValues.playbackForwardSkipLengthSwipe,
            Keys.playerControlDuration: DefaultValues.playerControlDuration,
            Keys.tabBarIndex: 0,

            // other
            Keys.appTheme: DefaultValues.appTheme.rawValue,
            Keys.hardwareDecoding: HardwareDecoding.hardware.rawValue,
            Keys.networkCaching: NetworkCaching.normal.rawValue,
            Keys.networkSatIPChannelListUrl: DefaultValues.networkSatIPChannelListUrl,
            Keys.playerIsRepeatEnabled: DefaultValues.playerRepeatMode.rawValue,
            Keys.skipLoopFilter: DefaultValues.skipLoopFilter.rawValue,
            Keys.subtitlesFontColor: DefaultValues.subtitlesFontColor,
            Keys.subtitlesFontSize: DefaultValues.subtitlesFontSize,
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

    @objc var audioLibraryHideFeatArtists: Bool {
        get {
            userDefaults.bool(forKey: Keys.audioLibraryHideFeatArtists)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.audioLibraryHideFeatArtists)
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

    @objc var backupMediaLibrary: Bool {
        get {
            userDefaults.bool(forKey: Keys.backupMediaLibrary)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.backupMediaLibrary)
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

    @objc var continueAudioInBackgroundKey: Bool {
        get {
            userDefaults.bool(forKey: Keys.continueAudioInBackground)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.continueAudioInBackground)
        }
    }

    @objc var currentlyPlayingPlaylist: Bool {
        get {
            userDefaults.bool(forKey: Keys.currentlyPlayingPlaylist)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.currentlyPlayingPlaylist)
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

    @objc var mediaLibraryServiceDidForceRescan: Bool {
        get {
            userDefaults.bool(forKey: Keys.mediaLibraryServiceDidForceRescan)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.mediaLibraryServiceDidForceRescan)
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

    /// tvOS only
    @objc var playerUIShouldHide: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerUIShouldHide)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playerUIShouldHide)
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

    @objc var subtitlesBoldFont: Bool {
        get {
            userDefaults.bool(forKey: Keys.subtitlesBoldFont)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.subtitlesBoldFont)
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

    @objc var wifiSharingIPv6: Bool {
        get {
            userDefaults.bool(forKey: Keys.wifiSharingIPv6)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.wifiSharingIPv6)
        }
    }

    // Numbers

    @objc var castingConversionQuality: Int {
        get {
            userDefaults.integer(forKey: Keys.castingConversionQuality)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.castingConversionQuality)
        }
    }

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

    @objc var deinterlace: Int {
        get {
            userDefaults.integer(forKey: Keys.deinterlace)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.deinterlace)
        }
    }

    @objc var equalizerProfile: Int {
        get {
            userDefaults.integer(forKey: Keys.equalizerProfile)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.equalizerProfile)
        }
    }

    @objc var playbackBackwardSkipLength: Int {
        get {
            userDefaults.integer(forKey: Keys.playbackBackwardSkipLength)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playbackBackwardSkipLength)
        }
    }

    @objc var playbackBackwardSkipLengthSwipe: Int {
        get {
            userDefaults.integer(forKey: Keys.playbackBackwardSkipLengthSwipe)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playbackBackwardSkipLengthSwipe)
        }
    }

    @objc var playbackForwardSkipLength: Int {
        get {
            userDefaults.integer(forKey: Keys.playbackForwardSkipLength)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playbackForwardSkipLength)
        }
    }

    @objc var playbackForwardSkipLengthSwipe: Int {
        get {
            userDefaults.integer(forKey: Keys.playbackForwardSkipLengthSwipe)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playbackForwardSkipLengthSwipe)
        }
    }

    @objc var playbackSpeedDefaultValue: Float {
        get {
            userDefaults.float(forKey: Keys.playbackSpeedDefaultValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playbackSpeedDefaultValue)
        }
    }

    @objc var playerControlDuration: Int {
        get {
            userDefaults.integer(forKey: Keys.playerControlDuration)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.playerControlDuration)
        }
    }

    @objc var tabBarIndex: Int {
        get {
            userDefaults.integer(forKey: Keys.tabBarIndex)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.tabBarIndex)
        }
    }

    // Other

    var appTheme: AppTheme {
        get {
            let v = userDefaults.integer(forKey: Keys.appTheme)
            return AppTheme(rawValue: v) ?? DefaultValues.appTheme
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.appTheme)
        }
    }

    @objc var appThemeIsSystem: Bool {
        appTheme == .system
    }

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

    var skipLoopFilter: SkipLoopFilter {
        get {
            let v = userDefaults.integer(forKey: Keys.skipLoopFilter)
            return SkipLoopFilter(rawValue: v) ?? DefaultValues.skipLoopFilter
        }
        set {
            userDefaults.set(newValue, forKey: Keys.skipLoopFilter)
        }
    }

    @objc var skipLoopFilterObjC: Int {
        get {
            userDefaults.integer(forKey: Keys.skipLoopFilter)
        }
    }

    @objc var subtitlesFont: String {
        get {
            userDefaults.string(forKey: Keys.subtitlesFont) ?? DefaultValues.subtitlesFont
        }
        set {
            userDefaults.set(newValue, forKey: Keys.subtitlesFont)
        }
    }

    @objc var subtitlesFontColor: String {
        get {
            userDefaults.string(forKey: Keys.subtitlesFontColor) ?? DefaultValues.subtitlesFontColor
        }
        set {
            userDefaults.set(newValue, forKey: Keys.subtitlesFontColor)
        }
    }

    @objc var subtitlesFontSize: String {
        get {
            userDefaults.string(forKey: Keys.subtitlesFontSize) ?? DefaultValues.subtitlesFontSize
        }
        set {
            userDefaults.set(newValue, forKey: Keys.subtitlesFontSize)
        }
    }

    func videoLibraryGridLayout(collectionModelName: String? = nil, name: String) -> Bool {
        userDefaults.bool(forKey: Keys.videoLibraryGridLayout(collectionModelName: collectionModelName, name: name))
    }

    func setVideoLibraryGridLayout(collectionModelName: String? = nil, name: String, isGrid: Bool) {
        userDefaults.set(isGrid, forKey: Keys.videoLibraryGridLayout(collectionModelName: collectionModelName, name: name))
    }

    func audioLibraryGridLayout(collectionModelName: String? = nil, name: String) -> Bool {
        userDefaults.bool(forKey: Keys.audioLibraryGridLayout(collectionModelName: collectionModelName, name: name))
    }

    func setAudioLibraryGridLayout(collectionModelName: String? = nil, name: String, isGrid: Bool) {
        userDefaults.set(isGrid, forKey: Keys.audioLibraryGridLayout(collectionModelName: collectionModelName, name: name))
    }
}

// MARK: - Compatibility

extension VLCDefaults {
    @available(*, deprecated, message: "avoid using keys to access defaults directly, instead use properties on VLCDefaults")
    @objc(VLCDefaultsCompat)
    final class Compat: NSObject {
        static let appThemeKey: String = Keys.appTheme
        static let automaticallyPlayNextItemKey: String = Keys.automaticallyPlayNextItem
        static let backupMediaLibraryKey: String = Keys.backupMediaLibrary
        static let castingConversionQualityKey: String = Keys.castingConversionQuality
        static let continueAudioPlaybackKey: String = Keys.continueAudioPlayback
        static let continuePlaybackKey: String = Keys.continuePlayback
        static let defaultPreampLevelKey: String = Keys.defaultPreampLevel
        static let deinterlaceKey: String = Keys.deinterlace
        static let hardwareDecodingKey: String = Keys.hardwareDecoding
        static let hideLibraryInFilesAppKey: String = Keys.hideLibraryInFilesApp
        static let networkCachingKey: String = Keys.networkCaching
        static let playbackBackwardSkipLengthKey: String = Keys.playbackBackwardSkipLength
        static let playbackBackwardSkipLengthSwipeKey: String = Keys.playbackBackwardSkipLengthSwipe
        static let playbackForwardSkipLengthKey: String = Keys.playbackForwardSkipLength
        static let playbackForwardSkipLengthSwipeKey: String = Keys.playbackForwardSkipLengthSwipe
        static let playbackSpeedDefaultValueKey: String = Keys.playbackSpeedDefaultValue
        static let playerControlDurationKey: String = Keys.playerControlDuration
        static let skipLoopFilterKey: String = Keys.skipLoopFilter
        static let subtitlesFontColorKey: String = Keys.subtitlesFontColor
        static let subtitlesFontKey: String = Keys.subtitlesFont
        static let subtitlesFontSizeKey: String = Keys.subtitlesFontSize
        static let textEncodingKey: String = Keys.textEncoding

        override init() {
            fatalError("compat struct not intended to be instantiated")
        }
    }
}

// MARK: - Value Types

extension VLCDefaults {
    enum AppTheme: Int {
        case bright = 0
        case dark = 1
        case system = 2
    }
}

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

extension VLCDefaults {
    enum SkipLoopFilter: Int {
        case none = 0
        case nonRef = 1
        case nonKey = 3
    }
}

// MARK: - Keys

fileprivate enum Keys {
    // Avoid ever changing these values. Some are used as parameters in functions.
    // Changing a value also causes the locally stored value to become unreachable.
    static let alwaysPlayURLs = "kVLCSettingAlwaysPlayURLs"
    static let appTheme = "darkMode"
    static let appThemeBlack = "blackTheme"
    static let audioLibraryHideFeatArtists = "kVLCAudioLibraryHideFeatArtists"
    static let automaticallyPlayNextItem = "AutomaticallyPlayNextItem"
    static let backupMediaLibrary = "BackupMediaLibrary"
    static let brightnessGesture = "EnableBrightnessGesture"
    static let castingAudioPassthrough = "sout-chromecast-audio-passthrough"
    static let castingConversionQuality = "sout-chromecast-conversion-quality"
    static let closeGesture = "EnableCloseGesture"
    static let continueAudioInBackground = "BackgroundAudioPlayback"
    static let continueAudioPlayback = "ContinueAudioPlayback"
    static let continuePlayback = "ContinuePlayback"
    static let currentlyPlayingPlaylist = "isPlaylistCurrentlyPlaying"
    static let defaultPreampLevel = "pre-amp-level"
    static let deinterlace = "deinterlace"
    static let downloadArtwork = "download-artwork"
    static let enableMediaCellTextScrolling = "EnableMediaCellTextScrolling"
    static let equalizerProfile = "EqualizerProfile"
    static let equalizerProfileDisabled = "EqualizerDisabled"
    static let forceSMBV1 = "smb-force-v1"
    static let hardwareDecoding = "codec"
    static let hideLibraryInFilesApp = "HideLibraryInFilesApp"
    static let mediaLibraryServiceDidForceRescan = "MediaLibraryDidForceRescan"
    static let networkCaching = "network-caching"
    static let networkRTSPTCP = "rtsp-tcp"
    static let networkSatIPChannelListUrl = "satip-channellist-url"
    static let passcodeEnableBiometricAuth = "EnableBiometricAuth"
    static let pauseWhenShowingControls = "kVLCSettingPauseWhenShowingControls"
    static let playbackBackwardSkipLength = "playback-backward-skip-length"
    static let playbackBackwardSkipLengthSwipe = "playback-backward-skip-length-swipe"
    static let playbackForwardBackwardEqual = "playback-forward-backward-equal"
    static let playbackForwardSkipLength = "playback-forward-skip-length"
    static let playbackForwardSkipLengthSwipe = "playback-forward-skip-length-swipe"
    static let playbackLongTouchSpeedUp = "LongTouchSpeedUp"
    static let playbackSpeedDefaultValue = "playback-speed"
    static let playbackTapSwipeEqual = "playback-tap-swipe-equal"
    static let playerControlDuration = "kVLCSettingPlayerControlDuration"
    static let playerIsRepeatEnabled = "PlayerIsRepeatEnabled"
    static let playerIsShuffleEnabled = "PlayerIsShuffleEnabled"
    static let playerShouldRememberBrightness = "PlayerShouldRememberBrightness"
    static let playerShouldRememberState = "PlayerShouldRememberState"
    static let playerShowPlaybackSpeedShortcut = "kVLCPlayerShowPlaybackSpeedShortcut"
    static let playerUIShouldHide = "PlayerUIShouldHide"
    static let playlistPlayNextItem = "PlaylistPlayNextItem"
    static let playPauseGesture = "EnablePlayPauseGesture"
    static let restoreLastPlayedMedia = "RestoreLastPlayedMedia"
    static let seekGesture = "EnableSeekGesture"
    static let showArtworks = "ShowArtworks"
    static let showRemainingTime = "show-remaining-time"
    static let showThumbnails = "ShowThumbnails"
    static let skipLoopFilter = "avcodec-skiploopfilter"
    static let stretchAudio = "audio-time-stretch"
    static let subtitlesBoldFont = "quartztext-bold"
    static let subtitlesFont = "quartztext-font"
    static let subtitlesFontColor = "quartztext-color"
    static let subtitlesFontSize = "quartztext-rel-fontsize"
    static let tabBarIndex = "TabBarIndex"
    static let textEncoding = "subsdec-encoding"
    static let videoFullscreenPlayback = "AlwaysUseFullscreenForVideo"
    static let volumeGesture = "EnableVolumeGesture"
    static let wifiSharingIPv6 = "wifi-sharing-ipv6"

    static func videoLibraryGridLayout(collectionModelName: String? = nil, name: String) -> String {
        [
            "kVLCVideoLibraryGridLayout", collectionModelName, name
        ].compactMap { $0 }.joined()
    }

    static func audioLibraryGridLayout(collectionModelName: String? = nil, name: String) -> String {
        [
            "kVLCAudioLibraryGridLayout", collectionModelName, name
        ].compactMap { $0 }.joined()
    }
}

// MARK: - Default Values

fileprivate enum DefaultValues {
    static let appTheme: VLCDefaults.AppTheme = {
        if #available(iOS 13.0, *) {
            return .system
        }
        return .bright
    }()
    static let castingConversionQuality = 2
    static let deinterlace = Int(-1)
    static let equalizerProfile = Int(0)
    static let textEncoding = "Windows-1252"
    static let networkSatIPChannelListUrl = ""
    static let playbackBackwardSkipLength = 10
    static let playbackBackwardSkipLengthSwipe = 10
    static let playbackForwardSkipLength = 10
    static let playbackForwardSkipLengthSwipe = 10
    static let playbackSpeedDefaultValue = Float(1)
    static let playerControlDuration = 4
    static let playerRepeatMode = VLCRepeatMode.doNotRepeat
    static let skipLoopFilter = VLCDefaults.SkipLoopFilter.nonRef
    static let subtitlesFont = "HelveticaNeue"
    static let subtitlesFontColor = "16777215"
    static let subtitlesFontSize = "16"
}
