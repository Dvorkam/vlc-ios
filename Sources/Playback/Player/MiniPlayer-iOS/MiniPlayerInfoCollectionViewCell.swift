//
//  MiniPlayerInfoCollectionViewCell.swift
//  VLC-iOS
//
//  Created by mohamed sliem on 25/06/2024.
//  Copyright © 2024 VideoLAN. All rights reserved.
//

import UIKit

class MiniPlayerInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mediaTitleLabel: VLCMarqueeLabel!
    @IBOutlet weak var artistTitleLabel: VLCMarqueeLabel!

    private var playbackService = PlaybackService.sharedInstance()

    private var enableMarquee: Bool {
        return !UserDefaults.standard.bool(forKey: kVLCSettingEnableMediaCellTextScrolling)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        mediaTitleLabel.labelize = enableMarquee
        artistTitleLabel.labelize = enableMarquee
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mediaTitleLabel.text = ""
        artistTitleLabel.text = ""
    }

    func configure(for media: VLCMedia?) {
        guard let mlMedia = VLCMLMedia(forPlaying: media) else {
            return
        }

        mediaTitleLabel.text = handleMediaTitle(mlMedia: mlMedia)
        
        if mlMedia.subtype() == .albumTrack,
           let artistName = mlMedia.artist?.artistName() {
            artistTitleLabel.text = artistName
        } else {
            artistTitleLabel.isHidden = true
        }
        
    }
    
    // Helper function to handle getting title due to media type
    private func handleMediaTitle(mlMedia: VLCMLMedia) -> String {
        var title = mlMedia.title
        
        // Media Artist title and album
        if (mlMedia.subtype() == .albumTrack ||
            mlMedia.videoTracks?.isEmpty ?? true) &&
            !mlMedia.isExternalMedia() {
            if let album = mlMedia.album?.title {
                title += " - "
                title += album
            } else if let artist = mlMedia.artist?.title() {
                title += " - "
                title += artist
            }
        }
        return title
    }

}
