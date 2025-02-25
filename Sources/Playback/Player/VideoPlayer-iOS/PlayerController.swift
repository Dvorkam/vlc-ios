/*****************************************************************************
 * PlayerController.swift
 *
 * Copyright © 2020 VLC authors and VideoLAN
 *
 * Authors: Soomin Lee <bubu@mikan.io>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

struct MediaProjection {
    struct FOV {
        static let `default`: CGFloat = 80
        static let max: CGFloat = 150
        static let min: CGFloat = 20
    }
}

protocol PlayerControllerDelegate: AnyObject {
    func playerControllerExternalScreenDidConnect(_ playerController: PlayerController)
    func playerControllerExternalScreenDidDisconnect(_ playerController: PlayerController)
    func playerControllerApplicationBecameActive(_ playerController: PlayerController)
}

@objc(VLCPlayerController)
class PlayerController: NSObject {
    weak var delegate: PlayerControllerDelegate?

    private var playbackService: PlaybackService = PlaybackService.sharedInstance()

    // MARK: - States

    var isControlsHidden: Bool = false

    var lockedOrientation: UIInterfaceOrientation = .unknown

    var isInterfaceLocked: Bool = false

    var isTapSeeking: Bool = false

    // MARK: - UserDefaults computed properties getters

    var displayRemainingTime: Bool {
        return VLCDefaults.shared.showRemainingTime
    }

    var isVolumeGestureEnabled: Bool {
        return VLCDefaults.shared.volumeGesture
    }

    var isPlayPauseGestureEnabled: Bool {
        return VLCDefaults.shared.playPauseGesture
    }

    var isBrightnessGestureEnabled: Bool {
        return VLCDefaults.shared.brightnessGesture
    }

    var isSwipeSeekGestureEnabled: Bool {
        return VLCDefaults.shared.seekGesture
    }

    var isCloseGestureEnabled: Bool {
        return VLCDefaults.shared.closeGesture
    }

    var isSpeedUpGestureEnabled: Bool {
        return VLCDefaults.shared.playbackLongTouchSpeedUp
    }

    var isShuffleEnabled: Bool {
        return VLCDefaults.shared.playerIsShuffleEnabled
    }

    var isRepeatEnabled: VLCRepeatMode {
        return VLCDefaults.shared.playerIsRepeatEnabled
    }

    var isRememberStateEnabled: Bool {
        return VLCDefaults.shared.playerShouldRememberState
    }

    var isRememberBrightnessEnabled: Bool {
        return VLCDefaults.shared.playerShouldRememberBrightness
    }

    @objc override init() {
        super.init()
        setupObservers()
    }

    func updateUserDefaults() {

    }

    private func setupObservers() {
        let notificationCenter = NotificationCenter.default

        // External Screen
#if os(iOS)
        if #available(iOS 13.0, *) {
            notificationCenter.addObserver(self,
                                           selector: #selector(handleExternalScreenDidConnect),
                                           name: NSNotification.Name(rawValue: VLCNonInteractiveWindowSceneBecameActive),
                                           object: nil)
            notificationCenter.addObserver(self,
                                           selector: #selector(handleExternalScreenDidDisconnect),
                                           name: NSNotification.Name(rawValue: VLCNonInteractiveWindowSceneDisconnected),
                                           object: nil)
        } else {
            notificationCenter.addObserver(self,
                                           selector: #selector(handleExternalScreenDidConnect),
                                           name: UIScreen.didConnectNotification,
                                           object: nil)
            notificationCenter.addObserver(self,
                                           selector: #selector(handleExternalScreenDidDisconnect),
                                           name: UIScreen.didDisconnectNotification,
                                           object: nil)
        }
#else
        notificationCenter.addObserver(self,
                                       selector: #selector(handleExternalScreenDidConnect),
                                       name: NSNotification.Name(rawValue: VLCNonInteractiveWindowSceneBecameActive),
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(handleExternalScreenDidDisconnect),
                                       name: NSNotification.Name(rawValue: VLCNonInteractiveWindowSceneDisconnected),
                                       object: nil)
#endif
        // UIApplication
        notificationCenter.addObserver(self,
                                       selector: #selector(handleAppBecameActive),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)
    }
}

// MARK: - Observers

extension PlayerController {
    @objc func handleExternalScreenDidConnect() {
        delegate?.playerControllerExternalScreenDidConnect(self)
    }

    @objc func handleExternalScreenDidDisconnect() {
        delegate?.playerControllerExternalScreenDidDisconnect(self)
    }

    @objc func handleAppBecameActive() {
        delegate?.playerControllerApplicationBecameActive(self)
    }
}
