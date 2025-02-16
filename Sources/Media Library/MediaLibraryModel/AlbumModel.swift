/*****************************************************************************
 * AlbumModel.swift
 *
 * Copyright © 2018 VLC authors and VideoLAN
 * Copyright © 2018 Videolabs
 *
 * Authors: Soomin Lee <bubu@mikan.io>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class AlbumModel: AudioCollectionModel {
    typealias MLType = VLCMLAlbum

    var sortModel = SortModel([.alpha, .duration, .releaseDate, .trackNumber, .insertionDate, .lastPlaybackDate, .playCount])

    var observable = Observable<MediaLibraryBaseModelObserver>()

    var fileArrayLock = NSRecursiveLock()
    var files = [VLCMLAlbum]()

    private var artist: VLCMLArtist? = nil

    var cellType: BaseCollectionViewCell.Type {
        return UserDefaults.standard.bool(forKey: "\(kVLCAudioLibraryGridLayout)\(name)") ? MediaGridCollectionCell.self : MediaCollectionViewCell.self
    }

    var medialibrary: MediaLibraryService

    var name: String = "ALBUMS"

    var indicatorName: String = NSLocalizedString("ALBUMS", comment: "")

    var intialPageSize = 12
    var currentPage = 0
    var firstTime = true

    required init(medialibrary: MediaLibraryService) {
        defer {
            fileArrayLock.unlock()
        }
        self.medialibrary = medialibrary
        medialibrary.observable.addObserver(self)
        fileArrayLock.lock()
    }

    init(medialibrary: MediaLibraryService, artist: VLCMLArtist) {
        defer {
            fileArrayLock.unlock()
        }
        self.medialibrary = medialibrary
        self.artist = artist
        fileArrayLock.lock()
        if let albums = artist.albums() {
            files = albums
        } else {
            files = []
        }
        medialibrary.observable.addObserver(self)
    }

    func append(_ item: VLCMLAlbum) {
        defer {
            fileArrayLock.unlock()
        }
        fileArrayLock.lock()
        files.append(item)
    }

    func getMedia() {
        print("page", intialPageSize)
        currentPage += 1
        let offset = (currentPage - 1) * intialPageSize
        let mediaAtOffset = medialibrary.albums(sortingCriteria: sortModel.currentSort, desc: sortModel.desc, items: UInt32(intialPageSize), offset: UInt32(offset))

           for  album in mediaAtOffset {
                files.append(album)
            }

        observable.observers.forEach() {
            $0.value.observer?.mediaLibraryBaseModelReloadView()
        }
    }
}

// MARK: - Sort
extension AlbumModel {
    func sort(by criteria: VLCMLSortingCriteria, desc: Bool) {
        defer {
            fileArrayLock.unlock()
        }
        fileArrayLock.lock()
        sortModel.currentSort = criteria
        sortModel.desc = desc
        if firstTime {
            print("Intial Page" , intialPageSize)
            getMedia()
            firstTime = false
        } else {
            files.removeAll()
            intialPageSize = 12
            currentPage = 0
            getMedia()
        }
    }
}

// MARK: - Search
extension VLCMLAlbum: SearchableMLModel {
    func contains(_ searchString: String) -> Bool {
        var matches = false

        matches = matches || search(searchString, in: title)
        matches = matches || search(searchString, in: String(releaseYear()))
        matches = matches || search(searchString, in: shortSummary)
        matches = matches || search(searchString, in: albumArtist?.name ?? "")

        return matches
    }
}

// MARK: - MediaLibraryObserver

extension AlbumModel: MediaLibraryObserver {
    func medialibrary(_ medialibrary: MediaLibraryService, didAddAlbums albums: [VLCMLAlbum]) {
        albums.forEach({ append($0) })
        observable.observers.forEach() {
            $0.value.observer?.mediaLibraryBaseModelReloadView()
        }
    }

    func medialibrary(_ medialibrary: MediaLibraryService,
                      didModifyAlbumsWithIds albumsIds: [NSNumber]) {
        defer {
            fileArrayLock.unlock()
        }
        var albums = [VLCMLAlbum]()

        albumsIds.forEach() {
            guard let safeAlbum = medialibrary.medialib.album(withIdentifier: $0.int64Value)
                else {
                    return
            }
            albums.append(safeAlbum)
        }

        fileArrayLock.lock()
        files = swapModels(with: albums)
        observable.observers.forEach() {
            $0.value.observer?.mediaLibraryBaseModelReloadView()
        }
    }

    func medialibrary(_ medialibrary: MediaLibraryService, didDeleteAlbumsWithIds albumsIds: [NSNumber]) {
        defer {
            fileArrayLock.unlock()
        }
        fileArrayLock.lock()
        files.removeAll {
            albumsIds.contains(NSNumber(value: $0.identifier()))
        }
        observable.observers.forEach() {
            $0.value.observer?.mediaLibraryBaseModelReloadView()
        }
    }

    func medialibraryDidStartRescan() {
        defer {
            fileArrayLock.unlock()
        }
        fileArrayLock.lock()
        files.removeAll()
    }
}

extension VLCMLAlbum: MediaCollectionModel {
    func sortModel() -> SortModel? {
        return SortModel([.alpha, .album, .duration, .releaseDate])
    }

    func files(with criteria: VLCMLSortingCriteria,
               desc: Bool = false) -> [VLCMLMedia]? {
        return tracks(with: criteria, desc: desc)
    }

    func title() -> String {
        return albumArtistName()
    }
}

extension VLCMLAlbum {

    func numberOfTracksString() -> String {
        let trackCount = numberOfTracks()
        let tracksString = trackCount > 1 ? NSLocalizedString("TRACKS", comment: "") : NSLocalizedString("TRACK", comment: "")
        return String(format: tracksString, trackCount)
    }

    func albumName() -> String {
        return isUnknownAlbum() ? NSLocalizedString("UNKNOWN_ALBUM", comment: "") : title
    }

    func albumArtistName() -> String {
        guard let artist = albumArtist else {
            return NSLocalizedString("UNKNOWN_ARTIST", comment: "")
        }
        return artist.artistName()
    }

    func accessibilityText(editing: Bool) -> String? {
        if editing {
            return albumName() + " " + albumArtistName() + " " + numberOfTracksString()
        }
        return albumName() + " " + albumArtistName()
    }
}
