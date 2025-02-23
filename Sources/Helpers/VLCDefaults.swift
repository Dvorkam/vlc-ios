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
            Keys.enableMediaCellTextScrolling: false,
            Keys.hideLibraryInFilesApp: false,
            Keys.playerShouldRememberBrightness: false,
            Keys.playerShouldRememberState: true,
            Keys.playlistPlayNextItem: true,
            Keys.restoreLastPlayedMedia: true,
            Keys.showRemainingTime: false,

            // numbers
            Keys.defaultPreampLevel: Float(6)
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

    @objc var enableMediaCellTextScrolling: Bool {
        get {
            userDefaults.bool(forKey: Keys.enableMediaCellTextScrolling)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.enableMediaCellTextScrolling)
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
        static let hideLibraryInFilesAppKey: String = Keys.hideLibraryInFilesApp
        static let defaultPreampLevelKey: String = Keys.defaultPreampLevel

        override init() {
            fatalError("compat struct not intended to be instantiated")
        }
    }
}

// MARK: - Keys

fileprivate enum Keys {
    static let appThemeBlack = "blackTheme"
    static let automaticallyPlayNextItem = "AutomaticallyPlayNextItem"
    static let defaultPreampLevel = "pre-amp-level"
    static let enableMediaCellTextScrolling = "EnableMediaCellTextScrolling"
    static let hideLibraryInFilesApp = "HideLibraryInFilesApp"
    static let playerShouldRememberBrightness = "PlayerShouldRememberBrightness"
    static let playerShouldRememberState = "PlayerShouldRememberState"
    static let playlistPlayNextItem = "PlaylistPlayNextItem"
    static let restoreLastPlayedMedia = "RestoreLastPlayedMedia"
    static let showRemainingTime = "show-remaining-time"

    static func videoLibraryGridLayout(collectionModelName: String? = nil, name: String) -> String {
        [
            "kVLCVideoLibraryGridLayout", collectionModelName, name
        ].compactMap { $0 }.joined()
    }
}
