/*****************************************************************************
 * AudioMiniPlayer.swift
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2019 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Soomin Lee <bubu # mikan.io>
 *          Diogo Simao Marques <dogo@videolabs.io>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

enum MiniPlayerVerticalPosition {
    case bottom
    case top
}

enum MiniPlayerHorizontalPosition {
    case left
    case right
    case center
}

struct MiniPlayerPosition {
    var vertical: MiniPlayerVerticalPosition
    var horizontal: MiniPlayerHorizontalPosition
}

@objc enum PanDirection: Int {
    case vertical
    case horizontal
}

@objc(VLCAudioMiniPlayer)
class AudioMiniPlayer: UIView, MiniPlayer, QueueViewControllerDelegate {
    @objc static let height: Float = 72.0
    var visible: Bool = false
    var contentHeight: Float {
        return AudioMiniPlayer.height
    }

    @IBOutlet private weak var audioMiniPlayer: UIView!
    @IBOutlet private weak var artworkImageView: UIImageView!
    @IBOutlet private weak var artworkBlurImageView: UIImageView!
    @IBOutlet weak var artworkBlurView: UIVisualEffectView!
    @IBOutlet weak var mediaInfoCollectionView: UICollectionView!
    @IBOutlet private weak var progressBarView: UIProgressView!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var repeatButton: UIButton!
    @IBOutlet private weak var shuffleButton: UIButton!

    @IBOutlet weak var stopOverlay: UIView!
    @IBOutlet weak var stopImageView: UIImageView!
    
    private var previousMediaBounceIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MiniPrev")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let draggingDelegate: MiniPlayerDraggingDelegate

    private let animationDuration = 0.2

    private var mediaService: MediaLibraryService
    private lazy var playbackService = PlaybackService.sharedInstance()
    private var mediaList: VLCMediaList {
        playbackService.isShuffleMode ? playbackService.shuffledList : playbackService.mediaList
    }

    private var isRepeatAllMode: Bool {
       return playbackService.repeatMode == .repeatAllItems
    }
    
    private var queueViewController: QueueViewController?

    var position = MiniPlayerPosition(vertical: .bottom, horizontal: .center)
    var originY: CGFloat = 0.0
    var tapticPosition = MiniPlayerPosition(vertical: .bottom, horizontal: .center)
    var panDirection: PanDirection = .vertical

    //Media Info CollectinView Offset Info
    var scrollOffsetBeforeDragging: CGPoint = .zero
    var scrollOffsetAfterDecelerating: CGPoint = .zero

    var stopGestureEnabled: Bool {
        if #available(iOS 13.0, *) {
            return false
        } else {
            return true
        }
    }

    @objc init(service: MediaLibraryService, draggingDelegate: MiniPlayerDraggingDelegate) {
        self.mediaService = service
        self.draggingDelegate = draggingDelegate
        super.init(frame: .zero)
        initView()
        setupConstraint()
        setupMediaInfoCollectionView()
        setupPreviousMediaBounceImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //Update the cell size when orientation changed
        DispatchQueue.main.async {
            guard let flowLayout = self.mediaInfoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                return
            }
            flowLayout.itemSize = self.mediaInfoCollectionView.frame.size
            flowLayout.invalidateLayout()
            self.mediaInfoCollectionView.invalidateIntrinsicContentSize()
            self.updateMediaInfoIndex()
        }
    }
    
    func updatePlayPauseButton() {
        playPauseButton.isSelected = playbackService.isPlaying
    }

    func updateRepeatButton() {
        switch playbackService.repeatMode {
        case .doNotRepeat:
            repeatButton.setImage(UIImage(named: "iconRepeatLarge"), for: .normal)
            repeatButton.tintColor = .white
        case .repeatCurrentItem:
            repeatButton.setImage(UIImage(named: "iconRepeatOneOnLarge"), for: .normal)
            repeatButton.tintColor = PresentationTheme.current.colors.orangeUI
        case .repeatAllItems:
            repeatButton.setImage(UIImage(named: "iconRepeatOnLarge"), for: .normal)
            repeatButton.tintColor = PresentationTheme.current.colors.orangeUI
        @unknown default:
            assertionFailure("AudioMiniPlayer.updateRepeatButton: unhandled case.")
        }
    }

    func updateShuffleButton() {
        let colors = PresentationTheme.current.colors
        let isShuffleMode = playbackService.isShuffleMode
        let image = isShuffleMode ? UIImage(named: "iconShuffleOnLarge") : UIImage(named: "iconShuffleLarge")

        shuffleButton.setImage(image, for: .normal)
        shuffleButton.tintColor = isShuffleMode ? colors.orangeUI : colors.cellTextColor
    }

    @objc func setupQueueViewController(with view: QueueViewController) {
        queueViewController = view
        queueViewController?.delegate = self
    }

    func setupMediaInfoCollectionView() {
        mediaInfoCollectionView.register(UINib(nibName: "MiniPlayerInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MiniPlayerInfoCollectionViewCell")
        mediaInfoCollectionView.delegate = self
        mediaInfoCollectionView.dataSource = self
    }
}

// MARK: - Private initializers

private extension AudioMiniPlayer {
    private func initView() {
        Bundle.main.loadNibNamed("AudioMiniPlayer", owner: self, options: nil)
        addSubview(audioMiniPlayer)

        audioMiniPlayer.clipsToBounds = true
        audioMiniPlayer.layer.cornerRadius = 4
        audioMiniPlayer.layer.borderWidth = 0.5
        audioMiniPlayer.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

        progressBarView.clipsToBounds = true

        if #available(iOS 11.0, *) {
            artworkImageView.accessibilityIgnoresInvertColors = true
            artworkBlurImageView.accessibilityIgnoresInvertColors = true
        }
        artworkImageView.clipsToBounds = true
        artworkImageView.layer.cornerRadius = 2

        playPauseButton.accessibilityLabel = NSLocalizedString("PLAY_PAUSE_BUTTON", comment: "")
        nextButton.accessibilityLabel = NSLocalizedString("NEXT_BUTTON", comment: "")
        previousButton.accessibilityLabel = NSLocalizedString("PREV_BUTTON", comment: "")
        isUserInteractionEnabled = true

        if #available(iOS 13.0, *) {
            addContextMenu()
        }
    }

    private func setupConstraint() {
        var guide: LayoutAnchorContainer = self

        if #available(iOS 11.0, *) {
            guide = safeAreaLayoutGuide
        }
        audioMiniPlayer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([audioMiniPlayer.leadingAnchor.constraint(equalTo: guide.leadingAnchor,
                                                                              constant: 8),
                                     audioMiniPlayer.trailingAnchor.constraint(equalTo: guide.trailingAnchor,
                                                                               constant: -8),
                                     audioMiniPlayer.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                                             constant: -8),
                                     ])
    }

    private func applyCustomEqualizerProfileIfNeeded() {
        let userDefaults = UserDefaults.standard
        guard userDefaults.bool(forKey: kVLCCustomProfileEnabled) else {
            return
        }

        let profileIndex = userDefaults.integer(forKey: kVLCSettingEqualizerProfile)
        let encodedData = userDefaults.data(forKey: kVLCCustomEqualizerProfiles)

        guard let encodedData = encodedData,
              let customProfiles = NSKeyedUnarchiver(forReadingWith: encodedData).decodeObject(forKey: "root") as? CustomEqualizerProfiles,
              profileIndex < customProfiles.profiles.count else {
            return
        }

        let selectedProfile = customProfiles.profiles[profileIndex]
        playbackService.preAmplification = CGFloat(selectedProfile.preAmpLevel)

        for (index, frequency) in selectedProfile.frequencies.enumerated() {
            playbackService.setAmplification(CGFloat(frequency), forBand: UInt32(index))
        }
    }
}

// MARK: - VLCPlaybackServiceDelegate

extension AudioMiniPlayer: VLCPlaybackServiceDelegate {
    func prepare(forMediaPlayback playbackService: PlaybackService) {
        updatePlayPauseButton()
        updateRepeatButton()
        updateShuffleButton()
        playbackService.delegate = self
        playbackService.recoverDisplayedMetadata()
        // For now, AudioMiniPlayer will be used for all media
        if !playbackService.isPlayingOnExternalScreen() && !playbackService.playAsAudio {
            playbackService.videoOutputView = artworkImageView
        }
        
        updateMediaInfoIndex()
        playModeUpdated()
        mediaInfoCollectionView.reloadData()
    }

    func mediaPlayerStateChanged(_ currentState: VLCMediaPlayerState,
                                 isPlaying: Bool,
                                 currentMediaHasTrackToChooseFrom: Bool,
                                 currentMediaHasChapters: Bool,
                                 for playbackService: PlaybackService) {
        updatePlayPauseButton()
        updateRepeatButton()
        updateShuffleButton()
        if let queueCollectionView = queueViewController?.queueCollectionView {
            queueCollectionView.reloadData()
        }

        if currentState == .opening {
            applyCustomEqualizerProfileIfNeeded()
        }
    }

    func displayMetadata(for playbackService: PlaybackService, metadata: VLCMetaData) {
        setMediaInfo(metadata)
    }

    func playbackPositionUpdated(_ playbackService: PlaybackService) {
        progressBarView.progress = playbackService.playbackPosition
    }

    func reloadPlayQueue() {
        guard let queueViewController = queueViewController else {
            return
        }

        queueViewController.reload()
    }
    
    func playModeUpdated() {
        if isRepeatAllMode {
            mediaInfoCollectionView.bounces = true
        } else {
            mediaInfoCollectionView.bounces = false
        }
        mediaInfoCollectionView.reloadData()
    }
}

// MARK: - UI Receivers

private extension AudioMiniPlayer {
    @IBAction private func handlePrevious(_ sender: UIButton) {
        playbackService.previous()
    }

    @IBAction private func handlePlayPause(_ sender: UIButton) {
        playbackService.playPause()
        updatePlayPauseButton()
    }

    @IBAction private func handleNext(_ sender: UIButton) {
        playbackService.next()
    }

    @IBAction private func handelRepeat(_ sender: UIButton) {
        playbackService.toggleRepeatMode()
        updateRepeatButton()
    }

    @IBAction private func handleShuffle(_ sender: UIButton? = nil) {
        playbackService.isShuffleMode = !playbackService.isShuffleMode
        updateShuffleButton()
    }

    @IBAction private func handleFullScreen(_ sender: Any) {
        if position.vertical == .top {
            dismissPlayqueue(with: nil)
        }

        let currentMedia: VLCMedia? = playbackService.currentlyPlayingMedia
        let mlMedia: VLCMLMedia? = VLCMLMedia.init(forPlaying: currentMedia)

        let selector: Selector
        if let mlMedia = mlMedia, (mlMedia.type() == .audio && playbackService.numberOfVideoTracks == 0) || playbackService.playAsAudio {
            selector = #selector(VLCPlayerDisplayController.showAudioPlayer)
        } else {
            selector = #selector(VLCPlayerDisplayController.showFullscreenPlayback)
        }

        UIApplication.shared.sendAction(selector,
                                        to: nil,
                                        from: self,
                                        for: nil)
    }

    @IBAction private func handleLongPressPlayPause(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        // case .began:
        // In the case of .began we could a an icon like the old miniplayer
        case .ended:
            playbackService.stopPlayback()
        case .cancelled, .failed:
            playbackService.playPause()
            updatePlayPauseButton()
        default:
            break
        }
    }
}

// MARK: - Playqueue UI

extension AudioMiniPlayer {

// MARK: Drag gesture handlers
    @IBAction func didDragAudioMiniPlayer(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .began:
                dragAudioMiniPlayerDidBegin(sender)
            case .changed:
                dragAudioMiniPlayerStateDidChange(sender)
            case .ended:
                dragAudioMiniPlayerDidEnd(sender)
            default:
                break
        }
    }

    private func dragAudioMiniPlayerDidBegin(_ sender: UIPanGestureRecognizer) {
        getPanDirection(sender)
        switch panDirection {
            case .vertical:
                queueViewController?.show()
            case .horizontal:
                break
        }
        originY = frame.minY
    }

    private func dragAudioMiniPlayerStateDidChange(_ sender: UIPanGestureRecognizer) {
        draggingDelegate.miniPlayerDragStateDidChange(self, sender: sender, panDirection: panDirection)
        sender.setTranslation(CGPoint.zero, in: UIApplication.shared.keyWindow?.rootViewController?.view)
        handleHapticFeedback()
        draggingDelegate.miniPlayerNeedsLayout(self)
    }

    private func dragAudioMiniPlayerDidEnd(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: UIApplication.shared.keyWindow?.rootViewController?.view)
        if let superview = superview {
            switch panDirection {
                case .vertical:
                    let limit = topBottomLimit(for: superview, with: position.vertical)
                    switch position.vertical {
                        case .top:
                            if self.frame.minY > limit || velocity.y > 1000.0 {
                                let completion: ((Bool) -> Void) = { _ in
                                    self.queueViewController?.hide()
                                }
                                dismissPlayqueue(with: completion)
                            } else {
                                showPlayqueue(in: superview)
                            }
                        case .bottom:
                            if stopGestureEnabled && self.frame.minY > originY + 10 {
                                playbackService.stopPlayback()
                            } else if self.frame.minY > limit && velocity.y > -1000.0 {
                                let completion: ((Bool) -> Void) = { _ in
                                    self.queueViewController?.hide()
                                }
                                dismissPlayqueue(with: completion)
                            } else {
                                showPlayqueue(in: superview)
                            }
                    }
                case .horizontal:
                        break
            }
            hideStopOverlay()
            draggingDelegate.miniPlayerDragDidEnd(self, sender: sender, panDirection: panDirection)
            UIView.animate(withDuration: animationDuration, animations: {
                self.draggingDelegate.miniPlayerNeedsLayout(self)
            })
        }
    }

// MARK: Drag helpers

    private func topBottomLimit(for superview: UIView, with position: MiniPlayerVerticalPosition) -> CGFloat {
        switch position {
            case .top:
                return superview.frame.maxY / 3
            case .bottom:
                return 2 * superview.frame.maxY / 3
        }
    }

    private func getPanDirection(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: UIApplication.shared.keyWindow?.rootViewController?.view)
        panDirection = abs(velocity.x) > abs(velocity.y) ? .horizontal : .vertical
    }


    private func verticalTranslation(in superview: UIView) -> Bool {
        var hapticFeedbackNeeded = false
        let limit = topBottomLimit(for: superview, with: position.vertical)
        if frame.minY < limit && tapticPosition.vertical == .bottom {
            hapticFeedbackNeeded = true
            queueViewController?.show()
            queueViewController?.view.alpha = 1.0
            tapticPosition.vertical = .top
        } else if frame.minY > limit && tapticPosition.vertical == .top {
            hapticFeedbackNeeded = true
            queueViewController?.view.alpha = 0.5
            tapticPosition.vertical = .bottom
        }
        if position.vertical == .bottom {
            if stopGestureEnabled && frame.minY > originY + 10 {
                stopImageView.image = UIImage(named: "stopIcon")
                stopOverlay.alpha = 0.8
                stopOverlay.isHidden = false
            } else if frame.minY > originY {
                queueViewController?.hide()
            } else {
                hideStopOverlay()
            }
        }
        return hapticFeedbackNeeded
    }

    private func handleHapticFeedback() {
        var hapticFeedbackNeeded = false
        if let superview = superview {
            switch panDirection {
                case .vertical:
                    hapticFeedbackNeeded = verticalTranslation(in: superview)
                case .horizontal:
                    break
            }
        }
        if hapticFeedbackNeeded, #available(iOS 10.0, *) {
            ImpactFeedbackGenerator().limitOverstepped()
        }
    }

// MARK: Show hide playqueue

    func showPlayqueue(in superview: UIView) {
        if let queueView = queueViewController?.view {
            position.vertical = .top
            tapticPosition.vertical = .top
            queueView.setNeedsUpdateConstraints()
            draggingDelegate.miniPlayerPositionToTop(self)
        }
    }

    func dismissPlayqueue(with completion: ((Bool) -> Void)?) {
        position.vertical = .bottom
        tapticPosition.vertical = .bottom

        draggingDelegate.miniPlayerPositionToBottom(self, completion: completion)
    }

    func hideStopOverlay() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.stopOverlay.alpha = 0.0
            self.stopOverlay.isHidden = true
        })
    }

}

// MARK: - Setters

private extension AudioMiniPlayer {
    private func setMediaInfo(_ metadata: VLCMetaData) {
        if (!UIAccessibility.isReduceTransparencyEnabled && metadata.isAudioOnly) ||
            playbackService.playAsAudio {
            // Only update the artwork image when the media is being played
            if playbackService.isPlaying {
                artworkImageView.image = metadata.artworkImage ?? UIImage(named: "no-artwork")
                artworkBlurImageView.image = metadata.artworkImage
                queueViewController?.reloadBackground(with: metadata.artworkImage)
                artworkBlurView.isHidden = false
            }

            playbackService.videoOutputView = nil
        } else {
            artworkImageView.image = nil
            artworkBlurImageView.image = nil
            artworkBlurView.isHidden = true
            queueViewController?.reloadBackground(with: nil)
            playbackService.videoOutputView = artworkImageView
        }
    }

    //Update or set media info collection view index with the currently playing media
    private func updateMediaInfoIndex() {
        guard let media = playbackService.currentlyPlayingMedia else { return }
        var mediaIndex: UInt
        mediaIndex = mediaList.index(of: media)
        
        guard let currentCell = mediaInfoCollectionView.visibleCells.first,
        let currentIndex = mediaInfoCollectionView.indexPath(for: currentCell) else { return }

        if abs(Int(mediaIndex) - currentIndex.row) == 1 {
            mediaInfoCollectionView.scrollToItem(at: IndexPath(row: Int(mediaIndex), section: 0),
                                                 at: .centeredHorizontally, animated: true)
        } else {
            mediaInfoCollectionView.scrollToItem(at: IndexPath(row: Int(mediaIndex), section: 0),
                                                 at: .centeredHorizontally, animated: false)
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate

@available(iOS 13.0, *)
extension AudioMiniPlayer: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: generateContextMenu)
    }

    private func generateContextMenu(_ suggestedActions: [UIMenuElement]) -> UIMenu? {
        var actions: [UIMenuElement] = []
        let defaultButtonColor: UIColor = PresentationTheme.current.colors.cellTextColor

        if shuffleButton.isHidden {
            let shuffleState: UIMenuElement.State = playbackService.isShuffleMode ? .on : .off
            let shuffleIconTint: UIColor = shuffleButton.tintColor
            let shuffleIcon = shuffleButton.image(for: .normal)?.withTintColor(shuffleIconTint, renderingMode: .alwaysOriginal)
            actions.append(
                UIAction(title: shuffleButton.currentTitle ?? NSLocalizedString("SHUFFLE", comment: ""),
                         image: shuffleIcon, state: shuffleState) {
                    action in
                    self.handleShuffle()
                }
            )
        }

        if repeatButton.isHidden {
            let repeatMode = playbackService.repeatMode
            var repeatActions: [UIMenuElement] = []

            let noRepeatState: UIMenuElement.State = repeatMode == .doNotRepeat ? .on : .off
            let noRepeatIconTint = repeatMode == .doNotRepeat ? PresentationTheme.current.colors.orangeUI : defaultButtonColor
            let noRepeatIcon = UIImage(named: "iconNoRepeat")?.withTintColor(noRepeatIconTint, renderingMode: .alwaysOriginal)
            repeatActions.append(
                UIAction(title: NSLocalizedString("MENU_REPEAT_DISABLED", comment: ""), image: noRepeatIcon, state: noRepeatState) {
                    action in
                    self.playbackService.repeatMode = .doNotRepeat
                    self.updateRepeatButton()
                }
            )

            let repeatOneState: UIMenuElement.State = repeatMode == .repeatCurrentItem ? .on : .off
            let repeatOneIconTint = repeatMode == .repeatCurrentItem ? PresentationTheme.current.colors.orangeUI : defaultButtonColor
            let repeatOneIcon = UIImage(named: "iconRepeatOne")?.withTintColor(repeatOneIconTint, renderingMode: .alwaysOriginal)
            repeatActions.append(
                UIAction(title: NSLocalizedString("MENU_REPEAT_SINGLE", comment: ""), image: repeatOneIcon, state: repeatOneState) {
                    action in
                    self.playbackService.repeatMode = .repeatCurrentItem
                    self.updateRepeatButton()
                }
            )

            let repeatAllState: UIMenuElement.State = repeatMode == .repeatAllItems ? .on : .off
            let repeatAllIconTint = repeatMode == .repeatAllItems ? PresentationTheme.current.colors.orangeUI : defaultButtonColor
            let repeatAllIcon = UIImage(named: "iconRepeat")?.withTintColor(repeatAllIconTint, renderingMode: .alwaysOriginal)
            repeatActions.append(
                UIAction(title: NSLocalizedString("MENU_REPEAT_ALL", comment: ""), image: repeatAllIcon, state: repeatAllState) {
                    action in
                    self.playbackService.repeatMode = .repeatAllItems
                    self.updateRepeatButton()
                }
            )

            actions.append(UIMenu(title: "", options: .displayInline, children: repeatActions))
        }

        actions.append(
            UIAction(title: NSLocalizedString("STOP_BUTTON", comment: ""),
                     image: UIImage(named: "stopIcon")?.withTintColor(defaultButtonColor, renderingMode: .alwaysOriginal)) {
                action in
                         self.playbackService.stopPlayback()
                         let completion: ((Bool) -> Void) = { _ in
                             self.queueViewController?.hide()
                         }
                         self.dismissPlayqueue(with: completion)
            }
        )

        return UIMenu(title: NSLocalizedString("MENU_PLAYBACK_CONTROLS", comment: ""), children: actions)
    }

    private func addContextMenu() {
        audioMiniPlayer.addInteraction(UIContextMenuInteraction(delegate: self))
    }
}

// MARK: - MiniPLayer Media Info CollectionView Delegate

extension AudioMiniPlayer: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // adding a cell to the count for buffering to achieve infinite scrolling in RepeatAllMode
        return isRepeatAllMode ? mediaList.count + 1 : mediaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MiniPlayerInfoCollectionViewCell",
            for: indexPath
        ) as? MiniPlayerInfoCollectionViewCell else {
            fatalError("Couldn't load MiniPlayerInfoCollectionViewCell")
        }
        
        let index: UInt = isRepeatAllMode
                  ? UInt(indexPath.row % mediaList.count)
                  : UInt(indexPath.row)
        
        let indexMedia = mediaList.media(at: index)
        cell.configure(for: indexMedia)

        return cell
    }
    
}

// MARK: - Media Info ScrollView Delegate

extension AudioMiniPlayer: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollOffsetBeforeDragging = scrollView.contentOffset
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && mediaInfoCollectionView.contentOffset.x >= 0 {
            handlePreviousNextAction()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let isBouncingOnLeftEdge = (scrollOffsetAfterDecelerating.x < -25)
      
        if isRepeatAllMode && isBouncingOnLeftEdge {
            handlePreviousNextAction(forcePrevious: true)
        } else if mediaInfoCollectionView.contentOffset.x >= 0 {
            handlePreviousNextAction()
        }
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let proposedOffset = targetContentOffset.pointee.x
        let previousOffset = scrollOffsetBeforeDragging
        let flowLayout = mediaInfoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        
        // current offset before scrolling end.
        //This helper for determining if there is bouncing happened.
        scrollOffsetAfterDecelerating = scrollView.contentOffset

        // Check if scrolling to the next or previous cell satisfies the width ratio.
        guard abs(proposedOffset - scrollOffsetBeforeDragging.x) > (0.4 * cellWidth) else {
            targetContentOffset.pointee = previousOffset
            return
        }

        let newOffset = calculateNewScrollOffset(
            velocity: velocity.x,
            proposedOffset: proposedOffset,
            cellWidth: cellWidth
        )

        targetContentOffset.pointee = CGPoint(x: newOffset, y: targetContentOffset.pointee.y)
    }
    
    // Calculate the new offset for scrolling
    private func calculateNewScrollOffset(
        velocity: CGFloat,
        proposedOffset: CGFloat,
        cellWidth: CGFloat
    ) -> CGFloat {
        var newOffset: CGFloat = scrollOffsetBeforeDragging.x

        if (velocity == 0 && proposedOffset > 0) || abs(velocity) < 0.4 {
            newOffset += proposedOffset > scrollOffsetBeforeDragging.x ? cellWidth : -cellWidth
        }

        if velocity > 0.4 {
            newOffset += cellWidth
        } else if velocity < -0.4 {
            newOffset -= cellWidth
        }

        return newOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        // Check if the user scrolls beyond the left (first cell)
        if offsetX < 0 {
            updatePreviousMediaBounceImage(alpha: abs(offsetX / 60))
        }
    }
}

// MARK: - Handler for Previous / Next Action through the Audio Mini Player

extension AudioMiniPlayer {
    private func setupPreviousMediaBounceImage() {
        previousMediaBounceIcon.image = UIImage(named: "MiniPrev")
        
        previousMediaBounceIcon.frame = CGRect(
            x: -45, y: mediaInfoCollectionView.frame.height / 2 - 17.5,
            width: 35, height: 35)
        
        mediaInfoCollectionView.addSubview(previousMediaBounceIcon)
    }
    
    func updatePreviousMediaBounceImage(alpha: CGFloat = 0.0) {
        previousMediaBounceIcon.alpha = alpha
    }
    
    private func handlePreviousNextAction(forcePrevious: Bool = false) {
        let finalContentOffset = mediaInfoCollectionView.contentOffset
        // Normal Mode
        if finalContentOffset.x > scrollOffsetBeforeDragging.x {
            playbackService.next()
        } else if finalContentOffset.x < scrollOffsetBeforeDragging.x || forcePrevious {
            playbackService.previousMedia()
        }
    }

    private func handlePreviousNextRepeatOnRepeatAll() {
        let finalContentOffset = mediaInfoCollectionView.contentOffset

        if finalContentOffset.x > (mediaInfoCollectionView.contentSize.width) {
            playbackService.next()
        } else {
            playbackService.previousMedia()
        }
    }
}

@objc protocol MiniPlayerDraggingDelegate {
    func miniPlayerDragStateDidChange(_ miniPlayer: AudioMiniPlayer, sender: UIPanGestureRecognizer, panDirection: PanDirection)
    func miniPlayerDragDidEnd(_ miniPlayer: AudioMiniPlayer, sender: UIPanGestureRecognizer, panDirection: PanDirection)
    func miniPlayerPositionToTop(_ miniPlayer: AudioMiniPlayer)
    func miniPlayerPositionToBottom(_ miniPlayer: AudioMiniPlayer, completion: ((Bool) -> Void)?)
    func miniPlayerCenterHorizontaly(_ miniPlayer: AudioMiniPlayer)
    func miniPlayerNeedsLayout(_ miniPlayer: AudioMiniPlayer)
}
