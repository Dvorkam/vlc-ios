/*****************************************************************************
 * TrackModel.swift
 *
 * Copyright © 2018 VLC authors and VideoLAN
 * Copyright © 2018 Videolabs
 *
 * Authors: Soomin Lee <bubu@mikan.io>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class TrackModel: NSObject, MediaModel {
    typealias MLType = VLCMLMedia

    var observable = Observable<MediaLibraryBaseModelObserver>()

    @objc var files = [VLCMLMedia]()
    var fileArrayLock = NSRecursiveLock()
    
    #if os(iOS)
    var cellType: BaseCollectionViewCell.Type {
        return UserDefaults.standard.bool(forKey: "\(kVLCAudioLibraryGridLayout)\(name)") ? MediaGridCollectionCell.self : MediaCollectionViewCell.self
    }
    #endif
    @objc var sortModel = SortModel([.alpha, .album, .duration, .fileSize, .insertionDate, .lastPlaybackDate, .playCount])
    
    
    var medialibrary: MediaLibraryService

    var name: String = "SONGS"

    var indicatorName: String = NSLocalizedString("SONGS", comment: "")

    @objc required init(medialibrary: MediaLibraryService) {
        defer {
            fileArrayLock.unlock()
        }
        self.medialibrary = medialibrary
        super.init()
        medialibrary.observable.addObserver(self)
        fileArrayLock.lock()
        files = medialibrary.media(ofType: .audio)
    }
    
    @objc func getmedia(at index: Int) -> VLCMLMedia {
        let media = files[index]
        return media
    }
}

// MARK: - Sort
//#if os(iOS)
extension TrackModel {
    func sort(by criteria: VLCMLSortingCriteria, desc: Bool) {
        // FIXME: Currently if sorted by name, the files are sorted by filename but displaying title
        defer {
            fileArrayLock.unlock()
        }
        fileArrayLock.lock()
        files = medialibrary.media(ofType: .audio,
                                   sortingCriteria: criteria,
                                   desc: desc)
        sortModel.currentSort = criteria
        sortModel.desc = desc
        observable.observers.forEach() {
            $0.value.observer?.mediaLibraryBaseModelReloadView()
        }
    }
}
//#endif
// MARK: - MediaLibraryObserver

extension TrackModel: MediaLibraryObserver {
    func medialibrary(_ medialibrary: MediaLibraryService, didAddTracks tracks: [VLCMLMedia]) {
        defer {
            fileArrayLock.unlock()
        }
        fileArrayLock.lock()
        tracks.forEach({ append($0) })
        observable.observers.forEach() {
            $0.value.observer?.mediaLibraryBaseModelReloadView()
        }
    }

    func medialibrary(_ medialibrary: MediaLibraryService, didModifyTracks tracks: [VLCMLMedia]) {
        if !tracks.isEmpty {
            defer {
                fileArrayLock.unlock()
            }
            fileArrayLock.lock()
            files = swapModels(with: tracks)
            observable.observers.forEach() {
                $0.value.observer?.mediaLibraryBaseModelReloadView()
            }
        }
    }

    func medialibrary(_ medialibrary: MediaLibraryService, didDeleteMediaWithIds ids: [NSNumber]) {
        defer {
            fileArrayLock.unlock()
        }
        fileArrayLock.lock()
        files = files.filter() {
            for id in ids where $0.identifier() == id.int64Value {
                return false
            }
            return true
        }
        observable.observers.forEach() {
            $0.value.observer?.mediaLibraryBaseModelReloadView()
        }
    }
}
