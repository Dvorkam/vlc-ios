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

extension Notification.Name {
    static let VLCDefaultsDidUpdate = Notification.Name("VLCDefaultsDidUpdate")
}

@objc final class VLCDefaults: NSObject {
    @objc static let shared = VLCDefaults()

    private let userDefaults = UserDefaults.standard

    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(defaultsDidChange),
                                               name: UserDefaults.didChangeNotification,
                                               object: nil)
    }

    @objc func registerDefaults() {
        var dict: [String: Any] = [
            // bools
            Keys.alwaysPlayURLs: false,
            Keys.appThemeBlack: false,
            Keys.audioLibraryHideFeatArtists: false,
            Keys.audioLibraryHideTrackNumbers: false,
            Keys.automaticallyPlayNextItem: true,
            Keys.backupMediaLibrary: false,
            Keys.brightnessGesture: true,
            Keys.castingAudioPassthrough: false,
            Keys.closeGesture: true,
            Keys.continueAudioInBackground: true,
            Keys.currentlyPlayingPlaylist: false,
            Keys.customEqualizerProfileEnabled: false,
            Keys.optimizeTitles: false,
            Keys.disableGrouping: false,
            Keys.disableSubtitles: false,
            Keys.downloadArtwork: true,
            Keys.enableMediaCellTextScrolling: false,
            Keys.equalizerProfileDisabled: true,
            Keys.equalizerSnapBands: false,
            Keys.forceSMBV1: true,
            Keys.hasActiveSubscription: false,
            Keys.hasLaunchedBefore: false,
            Keys.hideLibraryInFilesApp: false,
            Keys.lockscreenSkip: false,
            Keys.mediaLibraryServiceDidForceRescan: false,
            Keys.networkRTSPTCP: false,
            Keys.passcodeEnableBiometricAuth: true,
            Keys.passcodeOn: false,
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
            Keys.remoteControlSkip: false,
            Keys.restoreLastPlayedMedia: true,
            Keys.rotationLock: false,
            Keys.saveDebugLogs: false,
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
            Keys.hasNaggedThisMonth: 0,
            Keys.numberOfLaunches: 0,
            Keys.playbackBackwardSkipLength: DefaultValues.playbackBackwardSkipLength,
            Keys.playbackBackwardSkipLengthSwipe: DefaultValues.playbackBackwardSkipLengthSwipe,
            Keys.playbackForwardSkipLength: DefaultValues.playbackForwardSkipLength,
            Keys.playbackForwardSkipLengthSwipe: DefaultValues.playbackForwardSkipLengthSwipe,
            Keys.playbackSpeedDefaultValue: DefaultValues.playbackSpeedDefaultValue,
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

    func reset() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults().removePersistentDomain(forName: appDomain)
    }

    @objc private func defaultsDidChange(_: Notification) {
        NotificationCenter.default.post(name: .VLCDefaultsDidUpdate, object: self)
    }

    // These methods are not strictly necessary, however, they help prevent a
    // programmer error whereby attempts to write invalid data types will get
    // past the compiler, but will cause a crash at runtime.

    fileprivate func set(bool b: Bool, forKey key: String) {
        userDefaults.set(b, forKey: key)
    }

    fileprivate func set(float f: Float, forKey key: String) {
        userDefaults.set(f, forKey: key)
    }

    fileprivate func set(integer i: Int, forKey key: String) {
        userDefaults.set(i, forKey: key)
    }

    fileprivate func set(string s: String, forKey key: String) {
        userDefaults.set(s, forKey: key)
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
            set(bool: newValue, forKey: Keys.alwaysPlayURLs)
        }
    }

    @objc var appThemeBlack: Bool {
        get {
            userDefaults.bool(forKey: Keys.appThemeBlack)
        }
        set {
            set(bool: newValue, forKey: Keys.appThemeBlack)
        }
    }

    @objc var audioLibraryHideFeatArtists: Bool {
        get {
            userDefaults.bool(forKey: Keys.audioLibraryHideFeatArtists)
        }
        set {
            set(bool: newValue, forKey: Keys.audioLibraryHideFeatArtists)
        }
    }

    @objc var audioLibraryHideTrackNumbers: Bool {
        get {
            userDefaults.bool(forKey: Keys.audioLibraryHideTrackNumbers)
        }
        set {
            set(bool: newValue, forKey: Keys.audioLibraryHideTrackNumbers)
        }
    }

    @objc var automaticallyPlayNextItem: Bool {
        get {
            userDefaults.bool(forKey: Keys.automaticallyPlayNextItem)
        }
        set {
            set(bool: newValue, forKey: Keys.automaticallyPlayNextItem)
        }
    }

    @objc var backupMediaLibrary: Bool {
        get {
            userDefaults.bool(forKey: Keys.backupMediaLibrary)
        }
        set {
            set(bool: newValue, forKey: Keys.backupMediaLibrary)
        }
    }

    @objc var brightnessGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.brightnessGesture)
        }
        set {
            set(bool: newValue, forKey: Keys.brightnessGesture)
        }
    }

    @objc var castingAudioPassthrough: Bool {
        get {
            userDefaults.bool(forKey: Keys.castingAudioPassthrough)
        }
        set {
            set(bool: newValue, forKey: Keys.castingAudioPassthrough)
        }
    }

    @objc var closeGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.closeGesture)
        }
        set {
            set(bool: newValue, forKey: Keys.closeGesture)
        }
    }

    @objc var continueAudioInBackgroundKey: Bool {
        get {
            userDefaults.bool(forKey: Keys.continueAudioInBackground)
        }
        set {
            set(bool: newValue, forKey: Keys.continueAudioInBackground)
        }
    }

    @objc var currentlyPlayingPlaylist: Bool {
        get {
            userDefaults.bool(forKey: Keys.currentlyPlayingPlaylist)
        }
        set {
            set(bool: newValue, forKey: Keys.currentlyPlayingPlaylist)
        }
    }

    @objc var customEqualizerProfileEnabled: Bool {
        get {
            userDefaults.bool(forKey: Keys.customEqualizerProfileEnabled)
        }
        set {
            set(bool: newValue, forKey: Keys.customEqualizerProfileEnabled)
        }
    }

    @objc var optimizeTitles: Bool {
        get {
            userDefaults.bool(forKey: Keys.optimizeTitles)
        }
        set {
            set(bool: newValue, forKey: Keys.optimizeTitles)
        }
    }

    @objc var disableGrouping: Bool {
        get {
            userDefaults.bool(forKey: Keys.disableGrouping)
        }
        set {
            set(bool: newValue, forKey: Keys.disableGrouping)
        }
    }

    @objc var disableSubtitles: Bool {
        get {
            userDefaults.bool(forKey: Keys.disableSubtitles)
        }
        set {
            set(bool: newValue, forKey: Keys.disableSubtitles)
        }
    }

    @objc var downloadArtwork: Bool {
        get {
            userDefaults.bool(forKey: Keys.downloadArtwork)
        }
        set {
            set(bool: newValue, forKey: Keys.downloadArtwork)
        }
    }

    @objc var enableMediaCellTextScrolling: Bool {
        get {
            userDefaults.bool(forKey: Keys.enableMediaCellTextScrolling)
        }
        set {
            set(bool: newValue, forKey: Keys.enableMediaCellTextScrolling)
        }
    }

    @objc var equalizerProfileDisabled: Bool {
        get {
            userDefaults.bool(forKey: Keys.equalizerProfileDisabled)
        }
        set {
            set(bool: newValue, forKey: Keys.equalizerProfileDisabled)
        }
    }

    @objc var equalizerSnapBands: Bool {
        get {
            userDefaults.bool(forKey: Keys.equalizerSnapBands)
        }
        set {
            set(bool: newValue, forKey: Keys.equalizerSnapBands)
        }
    }

    @objc var forceSMBV1: Bool {
        get {
            userDefaults.bool(forKey: Keys.forceSMBV1)
        }
        set {
            set(bool: newValue, forKey: Keys.forceSMBV1)
        }
    }

    @objc var hasActiveSubscription: Bool {
        get {
            userDefaults.bool(forKey: Keys.hasActiveSubscription)
        }
        set {
            set(bool: newValue, forKey: Keys.hasActiveSubscription)
        }
    }

    var hasLaunchedBefore: Bool {
        userDefaults.bool(forKey: Keys.hasLaunchedBefore)
    }

    func setHasLaunchedBeforeIfNeeded() {
        if !hasLaunchedBefore {
            userDefaults.set(true, forKey: Keys.hasLaunchedBefore)
        }
    }

    @objc var hideLibraryInFilesApp: Bool {
        get {
            userDefaults.bool(forKey: Keys.hideLibraryInFilesApp)
        }
        set {
            set(bool: newValue, forKey: Keys.hideLibraryInFilesApp)
        }
    }

    @objc var lockscreenSkip: Bool {
        get {
            userDefaults.bool(forKey: Keys.lockscreenSkip)
        }
        set {
            set(bool: newValue, forKey: Keys.lockscreenSkip)
        }
    }

    @objc var mediaLibraryServiceDidForceRescan: Bool {
        get {
            userDefaults.bool(forKey: Keys.mediaLibraryServiceDidForceRescan)
        }
        set {
            set(bool: newValue, forKey: Keys.mediaLibraryServiceDidForceRescan)
        }
    }

    @objc var networkRTSPTCP: Bool {
        get {
            userDefaults.bool(forKey: Keys.networkRTSPTCP)
        }
        set {
            set(bool: newValue, forKey: Keys.networkRTSPTCP)
        }
    }

    @objc var pauseWhenShowingControls: Bool {
        get {
            userDefaults.bool(forKey: Keys.pauseWhenShowingControls)
        }
        set {
            set(bool: newValue, forKey: Keys.pauseWhenShowingControls)
        }
    }

    var playbackForwardBackwardEqual: Bool {
        get {
            userDefaults.bool(forKey: Keys.playbackForwardBackwardEqual)
        }
        set {
            set(bool: newValue, forKey: Keys.playbackForwardBackwardEqual)
        }
    }

    @objc var playbackLongTouchSpeedUp: Bool {
        get {
            userDefaults.bool(forKey: Keys.playbackLongTouchSpeedUp)
        }
        set {
            set(bool: newValue, forKey: Keys.playbackLongTouchSpeedUp)
        }
    }

    @objc var playbackTapSwipeEqual: Bool {
        get {
            userDefaults.bool(forKey: Keys.playbackTapSwipeEqual)
        }
        set {
            set(bool: newValue, forKey: Keys.playbackTapSwipeEqual)
        }
    }

    @objc var playerIsShuffleEnabled: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerIsShuffleEnabled)
        }
        set {
            set(bool: newValue, forKey: Keys.playerIsShuffleEnabled)
        }
    }

    @objc var playerShouldRememberBrightness: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerShouldRememberBrightness)
        }
        set {
            set(bool: newValue, forKey: Keys.playerShouldRememberBrightness)
        }
    }

    @objc var playerShouldRememberState: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerShouldRememberState)
        }
        set {
            set(bool: newValue, forKey: Keys.playerShouldRememberState)
        }
    }

    @objc var passcodeEnableBiometricAuth: Bool {
        get {
            userDefaults.bool(forKey: Keys.passcodeEnableBiometricAuth)
        }
        set {
            set(bool: newValue, forKey: Keys.passcodeEnableBiometricAuth)
        }
    }

    @objc var passcodeOn: Bool {
        get {
            userDefaults.bool(forKey: Keys.passcodeOn)
        }
        set {
            set(bool: newValue, forKey: Keys.passcodeOn)
        }
    }

    @objc var playerShowPlaybackSpeedShortcut: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerShowPlaybackSpeedShortcut)
        }
        set {
            set(bool: newValue, forKey: Keys.playerShowPlaybackSpeedShortcut)
        }
    }

    /// tvOS only
    @objc var playerUIShouldHide: Bool {
        get {
            userDefaults.bool(forKey: Keys.playerUIShouldHide)
        }
        set {
            set(bool: newValue, forKey: Keys.playerUIShouldHide)
        }
    }

    @objc var playlistPlayNextItem: Bool {
        get {
            userDefaults.bool(forKey: Keys.playlistPlayNextItem)
        }
        set {
            set(bool: newValue, forKey: Keys.playlistPlayNextItem)
        }
    }

    @objc var playPauseGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.playPauseGesture)
        }
        set {
            set(bool: newValue, forKey: Keys.playPauseGesture)
        }
    }

    @objc var restoreLastPlayedMedia: Bool {
        get {
            userDefaults.bool(forKey: Keys.restoreLastPlayedMedia)
        }
        set {
            set(bool: newValue, forKey: Keys.restoreLastPlayedMedia)
        }
    }

    @objc var remoteControlSkip: Bool {
        get {
            userDefaults.bool(forKey: Keys.remoteControlSkip)
        }
        set {
            set(bool: newValue, forKey: Keys.remoteControlSkip)
        }
    }

    @objc var rotationLock: Bool {
        get {
            userDefaults.bool(forKey: Keys.rotationLock)
        }
        set {
            set(bool: newValue, forKey: Keys.rotationLock)
        }
    }

    @objc var saveDebugLogs: Bool {
        get {
            userDefaults.bool(forKey: Keys.saveDebugLogs)
        }
        set {
            set(bool: newValue, forKey: Keys.saveDebugLogs)
        }
    }

    @objc var seekGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.seekGesture)
        }
        set {
            set(bool: newValue, forKey: Keys.seekGesture)
        }
    }

    @objc var showArtworks: Bool {
        get {
            userDefaults.bool(forKey: Keys.showArtworks)
        }
        set {
            set(bool: newValue, forKey: Keys.showArtworks)
        }
    }

    @objc var showRemainingTime: Bool {
        get {
            userDefaults.bool(forKey: Keys.showRemainingTime)
        }
        set {
            set(bool: newValue, forKey: Keys.showRemainingTime)
        }
    }

    @objc var showThumbnails: Bool {
        get {
            userDefaults.bool(forKey: Keys.showThumbnails)
        }
        set {
            set(bool: newValue, forKey: Keys.showThumbnails)
        }
    }

    @objc var stretchAudio: Bool {
        get {
            userDefaults.bool(forKey: Keys.stretchAudio)
        }
        set {
            set(bool: newValue, forKey: Keys.stretchAudio)
        }
    }

    @objc var subtitlesBoldFont: Bool {
        get {
            userDefaults.bool(forKey: Keys.subtitlesBoldFont)
        }
        set {
            set(bool: newValue, forKey: Keys.subtitlesBoldFont)
        }
    }

    @objc var videoFullscreenPlayback: Bool {
        get {
            userDefaults.bool(forKey: Keys.videoFullscreenPlayback)
        }
        set {
            set(bool: newValue, forKey: Keys.videoFullscreenPlayback)
        }
    }

    @objc var volumeGesture: Bool {
        get {
            userDefaults.bool(forKey: Keys.volumeGesture)
        }
        set {
            set(bool: newValue, forKey: Keys.volumeGesture)
        }
    }

    @objc var wifiSharingIPv6: Bool {
        get {
            userDefaults.bool(forKey: Keys.wifiSharingIPv6)
        }
        set {
            set(bool: newValue, forKey: Keys.wifiSharingIPv6)
        }
    }

    // Numbers

    @objc var castingConversionQuality: Int {
        get {
            userDefaults.integer(forKey: Keys.castingConversionQuality)
        }
        set {
            set(integer: newValue, forKey: Keys.castingConversionQuality)
        }
    }

    @objc var continueAudioPlayback: Int {
        get {
            userDefaults.integer(forKey: Keys.continueAudioPlayback)
        }
        set {
            set(integer: newValue, forKey: Keys.continueAudioPlayback)
        }
    }

    @objc var continuePlayback: Int {
        get {
            userDefaults.integer(forKey: Keys.continuePlayback)
        }
        set {
            set(integer: newValue, forKey: Keys.continuePlayback)
        }
    }

    @objc var defaultPreampLevel: Float {
        get {
            userDefaults.float(forKey: Keys.defaultPreampLevel)
        }
        set {
            set(float: newValue, forKey: Keys.defaultPreampLevel)
        }
    }

    @objc var deinterlace: Int {
        get {
            userDefaults.integer(forKey: Keys.deinterlace)
        }
        set {
            set(integer: newValue, forKey: Keys.deinterlace)
        }
    }

    @objc var equalizerProfile: Int {
        get {
            userDefaults.integer(forKey: Keys.equalizerProfile)
        }
        set {
            set(integer: newValue, forKey: Keys.equalizerProfile)
        }
    }

    @objc var hasNaggedThisMonth: Int {
        get {
            userDefaults.integer(forKey: Keys.hasNaggedThisMonth)
        }
        set {
            set(integer: newValue, forKey: Keys.hasNaggedThisMonth)
        }
    }

    @objc var numberOfLaunches: Int {
        userDefaults.integer(forKey: Keys.numberOfLaunches)
    }

    @objc func incrementNumberOfLaunches() {
        userDefaults.set(numberOfLaunches + 1, forKey: Keys.numberOfLaunches)
    }

    @objc func resetNumberOfLaunches() {
        userDefaults.set(0, forKey: Keys.numberOfLaunches)
    }

    @objc var playbackBackwardSkipLength: Int {
        get {
            userDefaults.integer(forKey: Keys.playbackBackwardSkipLength)
        }
        set {
            set(integer: newValue, forKey: Keys.playbackBackwardSkipLength)
        }
    }

    @objc var playbackBackwardSkipLengthSwipe: Int {
        get {
            userDefaults.integer(forKey: Keys.playbackBackwardSkipLengthSwipe)
        }
        set {
            set(integer: newValue, forKey: Keys.playbackBackwardSkipLengthSwipe)
        }
    }

    @objc var playbackForwardSkipLength: Int {
        get {
            userDefaults.integer(forKey: Keys.playbackForwardSkipLength)
        }
        set {
            set(integer: newValue, forKey: Keys.playbackForwardSkipLength)
        }
    }

    @objc var playbackForwardSkipLengthSwipe: Int {
        get {
            userDefaults.integer(forKey: Keys.playbackForwardSkipLengthSwipe)
        }
        set {
            set(integer: newValue, forKey: Keys.playbackForwardSkipLengthSwipe)
        }
    }

    @objc var playbackSpeedDefaultValue: Float {
        get {
            userDefaults.float(forKey: Keys.playbackSpeedDefaultValue)
        }
        set {
            set(float: newValue, forKey: Keys.playbackSpeedDefaultValue)
        }
    }

    var playerBrightness: Float? {
        get {
            // Use data(forKey:) to determine if a value has been set at all
            userDefaults.data(forKey: Keys.playerBrightness).flatMap { _ in
                userDefaults.float(forKey: Keys.playerBrightness)
            }
        }
        set {
            if let newValue = newValue {
                set(float: newValue, forKey: Keys.playerBrightness)
            } else {
                userDefaults.removeObject(forKey: Keys.playerBrightness)
            }
        }
    }

    @objc var playerControlDuration: Int {
        get {
            userDefaults.integer(forKey: Keys.playerControlDuration)
        }
        set {
            set(integer: newValue, forKey: Keys.playerControlDuration)
        }
    }

    @objc var tabBarIndex: Int {
        get {
            userDefaults.integer(forKey: Keys.tabBarIndex)
        }
        set {
            set(integer: newValue, forKey: Keys.tabBarIndex)
        }
    }

    // Other

    var appTheme: AppTheme {
        get {
            let v = userDefaults.integer(forKey: Keys.appTheme)
            return AppTheme(rawValue: v) ?? DefaultValues.appTheme
        }
        set {
            set(integer: newValue.rawValue, forKey: Keys.appTheme)
        }
    }

    @objc var appThemeIsSystem: Bool {
        appTheme == .system
    }

#if os(iOS) || os(visionOS)
    var customEqualizerProfiles: CustomEqualizerProfiles? {
        get {
            guard let encodedData = userDefaults.data(forKey: Keys.customEqualizerProfiles) else {
                return nil
            }

            guard let decoded = try? NSKeyedUnarchiver(forReadingFrom: encodedData)
                .decodeObject(forKey: "root") as? CustomEqualizerProfiles else {
                return nil
            }

            return decoded
        }
        set {
            guard let newValue = newValue else {
                return
            }

            guard let encoded = try? NSKeyedArchiver
                .archivedData(withRootObject: newValue, requiringSecureCoding: false) else {
                return
            }

            userDefaults.setValue(encoded, forKey: Keys.customEqualizerProfiles)
        }
    }
#endif

    var hardwareDecoding: HardwareDecoding {
        get {
            guard let v = userDefaults.string(forKey: Keys.hardwareDecoding) else {
                return HardwareDecoding.hardware
            }

            return HardwareDecoding(rawValue: v) ?? .hardware
        }
        set {
            set(string: newValue.rawValue, forKey: Keys.hardwareDecoding)
        }
    }

    @objc var hardwareDecodingObjC: String {
        hardwareDecoding.rawValue
    }

#if os(iOS) || os(visionOS)
    var lastPlayedPlaylist: LastPlayedPlaylistModel? {
        get {
            guard let encodedData = userDefaults.data(forKey: Keys.lastPlayedPlaylist) else {
                return nil
            }

            guard let decoded = try? NSKeyedUnarchiver(forReadingFrom: encodedData)
                .decodeObject(forKey: "root") as? LastPlayedPlaylistModel else {
                return nil
            }

            return decoded
        }
        set {
            guard let newValue = newValue else {
                return
            }

            guard let encoded = try? NSKeyedArchiver
                .archivedData(withRootObject: newValue, requiringSecureCoding: false) else {
                return
            }

            userDefaults.setValue(encoded, forKey: Keys.lastPlayedPlaylist)
        }
    }
#endif

    var networkCaching: NetworkCaching {
        get {
            let v = userDefaults.integer(forKey: Keys.networkCaching)
            return NetworkCaching(rawValue: v) ?? .normal
        }
        set {
            set(integer: newValue.rawValue, forKey: Keys.networkCaching)
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
            set(string: newValue, forKey: Keys.networkSatIPChannelListUrl)
        }
    }

    @objc var playerIsRepeatEnabled: VLCRepeatMode {
        get {
            let v = userDefaults.integer(forKey: Keys.playerIsRepeatEnabled)
            return VLCRepeatMode(rawValue: v) ?? DefaultValues.playerRepeatMode
        }
        set {
            set(integer: newValue.rawValue, forKey: Keys.playerIsRepeatEnabled)
        }
    }

    @objc var textEncoding: String {
        get {
            userDefaults.string(forKey: Keys.textEncoding) ?? DefaultValues.textEncoding
        }
        set {
            set(string: newValue, forKey: Keys.textEncoding)
        }
    }

    var skipLoopFilter: SkipLoopFilter {
        get {
            let v = userDefaults.integer(forKey: Keys.skipLoopFilter)
            return SkipLoopFilter(rawValue: v) ?? DefaultValues.skipLoopFilter
        }
        set {
            set(integer: newValue.rawValue, forKey: Keys.skipLoopFilter)
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
            set(string: newValue, forKey: Keys.subtitlesFont)
        }
    }

    @objc var subtitlesFontColor: String {
        get {
            userDefaults.string(forKey: Keys.subtitlesFontColor) ?? DefaultValues.subtitlesFontColor
        }
        set {
            set(string: newValue, forKey: Keys.subtitlesFontColor)
        }
    }

    @objc var subtitlesFontSize: String {
        get {
            userDefaults.string(forKey: Keys.subtitlesFontSize) ?? DefaultValues.subtitlesFontSize
        }
        set {
            set(string: newValue, forKey: Keys.subtitlesFontSize)
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

#if os(iOS) || os(visionOS)
    func sortDefault(name: String) -> VLCMLSortingCriteria? {
        let k = Keys.sortDefault(name: name)

        // Use data(forKey:) to determine if a value has been set at all
        return userDefaults.data(forKey: k).flatMap { _ in
            let v = userDefaults.integer(forKey: k)
            return VLCMLSortingCriteria(rawValue: UInt(v))
        }
    }

    func setSortDefault(name: String, criteria: VLCMLSortingCriteria) {
        let k = Keys.sortDefault(name: name)
        userDefaults.set(criteria.rawValue, forKey: k)
    }

    func sortDescendingDefault(name: String) -> Bool {
        let k = Keys.sortDescendingDefault(name: name)
        return userDefaults.bool(forKey: k)
    }

    func setSortDescendingDefault(name: String, isDescending: Bool) {
        let k = Keys.sortDescendingDefault(name: name)
        userDefaults.set(isDescending, forKey: k)
    }
#endif
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
        static let disableGroupingKey: String = Keys.disableGrouping
        static let hardwareDecodingKey: String = Keys.hardwareDecoding
        static let hideLibraryInFilesAppKey: String = Keys.hideLibraryInFilesApp
        static let lockscreenSkipKey: String = Keys.lockscreenSkip
        static let networkCachingKey: String = Keys.networkCaching
        static let passcodeOnKey: String = Keys.passcodeOn
        static let playbackBackwardSkipLengthKey: String = Keys.playbackBackwardSkipLength
        static let playbackBackwardSkipLengthSwipeKey: String = Keys.playbackBackwardSkipLengthSwipe
        static let playbackForwardSkipLengthKey: String = Keys.playbackForwardSkipLength
        static let playbackForwardSkipLengthSwipeKey: String = Keys.playbackForwardSkipLengthSwipe
        static let playbackSpeedDefaultValueKey: String = Keys.playbackSpeedDefaultValue
        static let playerControlDurationKey: String = Keys.playerControlDuration
        static let remoteControlSkipKey: String = Keys.remoteControlSkip
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
        case black = 3
    }
}

extension VLCDefaults {
    enum HardwareDecoding: String, CustomStringConvertible {
        case software = "avcodec,all"
        case hardware = ""

        var description: String {
            switch self {
            case .software:
                return "Software"
            case .hardware:
                return "Hardware"
            }
        }
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
    static let audioLibraryHideTrackNumbers = "kVLCAudioLibraryHideTrackNumbers"
    static let automaticallyPlayNextItem = "AutomaticallyPlayNextItem"
    static let backupMediaLibrary = "BackupMediaLibrary"
    static let brightnessGesture = "EnableBrightnessGesture"
    static let castingAudioPassthrough = "sout-chromecast-audio-passthrough"
    static let castingConversionQuality = kVLCSettingCastingConversionQuality
    static let closeGesture = "EnableCloseGesture"
    static let continueAudioInBackground = "BackgroundAudioPlayback"
    static let continueAudioPlayback = "ContinueAudioPlayback"
    static let continuePlayback = "ContinuePlayback"
    static let currentlyPlayingPlaylist = "isPlaylistCurrentlyPlaying"
    static let customEqualizerProfileEnabled = "kVLCCustomProfileEnabled"
    static let customEqualizerProfiles = "kVLCCustomEqualizerProfiles"
    static let optimizeTitles = "MLDecrapifyTitles"
    static let defaultPreampLevel = "pre-amp-level"
    static let deinterlace = "deinterlace"
    static let disableGrouping = "MLDisableGrouping"
    static let disableSubtitles = "kVLCSettingDisableSubtitles"
    static let downloadArtwork = "download-artwork"
    static let enableMediaCellTextScrolling = "EnableMediaCellTextScrolling"
    static let equalizerProfile = "EqualizerProfile"
    static let equalizerProfileDisabled = "EqualizerDisabled"
    static let equalizerSnapBands = "EqualizerSnapBands"
    static let forceSMBV1 = "smb-force-v1"
    static let hardwareDecoding = "codec"
    static let hasActiveSubscription = "kVLCHasActiveSubscription"
    static let hasLaunchedBefore = "hasLaunchedBefore"
    static let hasNaggedThisMonth = "kVLCHasNaggedThisMonth"
    static let hideLibraryInFilesApp = "HideLibraryInFilesApp"
    static let lastPlayedPlaylist = "LastPlayedPlaylist"
    static let lockscreenSkip = "playback-lockscreen-skip"
    static let mediaLibraryServiceDidForceRescan = "MediaLibraryDidForceRescan"
    static let networkCaching = "network-caching"
    static let networkRTSPTCP = "rtsp-tcp"
    static let networkSatIPChannelListUrl = kVLCSettingNetworkSatIPChannelListUrl
    static let numberOfLaunches = "kVLCNumberOfLaunches"
    static let passcodeEnableBiometricAuth = "EnableBiometricAuth"
    static let passcodeOn = "PasscodeProtection"
    static let pauseWhenShowingControls = "kVLCSettingPauseWhenShowingControls"
    static let playbackBackwardSkipLength = "playback-backward-skip-length"
    static let playbackBackwardSkipLengthSwipe = "playback-backward-skip-length-swipe"
    static let playbackForwardBackwardEqual = "playback-forward-backward-equal"
    static let playbackForwardSkipLength = "playback-forward-skip-length"
    static let playbackForwardSkipLengthSwipe = "playback-forward-skip-length-swipe"
    static let playbackLongTouchSpeedUp = "LongTouchSpeedUp"
    static let playbackSpeedDefaultValue = "playback-speed"
    static let playbackTapSwipeEqual = "playback-tap-swipe-equal"
    static let playerBrightness = "playerbrightness"
    static let playerControlDuration = "kVLCSettingPlayerControlDuration"
    static let playerIsRepeatEnabled = "PlayerIsRepeatEnabled"
    static let playerIsShuffleEnabled = "PlayerIsShuffleEnabled"
    static let playerShouldRememberBrightness = "PlayerShouldRememberBrightness"
    static let playerShouldRememberState = "PlayerShouldRememberState"
    static let playerShowPlaybackSpeedShortcut = "kVLCPlayerShowPlaybackSpeedShortcut"
    static let playerUIShouldHide = "PlayerUIShouldHide"
    static let playlistPlayNextItem = "PlaylistPlayNextItem"
    static let playPauseGesture = "EnablePlayPauseGesture"
    static let remoteControlSkip = "playback-remote-control-skip"
    static let restoreLastPlayedMedia = "RestoreLastPlayedMedia"
    static let rotationLock = "kVLCSettingRotationLock"
    static let saveDebugLogs = "kVLCSaveDebugLogs"
    static let seekGesture = "EnableSeekGesture"
    static let showArtworks = "ShowArtworks"
    static let showRemainingTime = "show-remaining-time"
    static let showThumbnails = "ShowThumbnails"
    static let skipLoopFilter = "avcodec-skiploopfilter"
    static let stretchAudio = kVLCSettingStretchAudio
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

    static func sortDefault(name: String) -> String {
        [
            "SortDefault", name
        ].joined()
    }

    static func sortDescendingDefault(name: String) -> String {
        [
            "SortDescendingDefault", name
        ].joined()
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
