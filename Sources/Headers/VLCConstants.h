/*****************************************************************************
 * VLCConstants.h
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2013-2022 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan.org>
 *          Jean-Romain Prévost <jr # 3on.fr>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#define kVLCThemeDidChangeNotification @"themeDidChangeNotfication"
#define kVLCSettingSaveHTTPUploadServerStatus @"isHTTPServerOn"
#define kVLCSettingSubtitlesFilePath @"sub-file"
#define kVLCSubtitlesCacheFolderName @"cached-subtitles"
#define kVLCSettingNetworkSatIPChannelList @"satip-channelist"
#define kVLCSettingNetworkSatIPChannelListCustom @"CustomList"
#define kVLCSettingNetworkSatIPChannelListUrl @"satip-channellist-url"
#define kVLCSettingLastUsedSubtitlesSearchLanguage @"kVLCSettingLastUsedSubtitlesSearchLanguage"

#define kVLCRecentURLs @"recent-urls"
#define kVLCRecentURLTitles @"recent-url-titles"
#define kVLCPrivateWebStreaming @"private-streaming"
#define kVLChttpScanSubtitle @"http-scan-subtitle"
#define kVLCHTTPUploadDirectory @"Upload"
#define kVLCSettingStretchAudio @"audio-time-stretch"
#define kVLCLastPlayedMediaIdentifier @"LastPlayedMediaIdentifier"

#define kVLCPlayerOpenInMiniPlayer @"OpenInMiniPlayer"

#define kSupportedFileExtensions @"\\.(669|3g2|3gp|3gp2|3gpp|amv|asf|avi|bik|bin|crf|divx|drc|dv|evo|f4v|far|flv|gvi|gxf|hevc|iso|it|m1v|m2v|m2t|m2ts|m4v|mkv|mov|mp2|mp2v|mp4|mp4v|mpe|mpeg|mpeg1|mpeg2|mpeg4|mpg|mpv2|mtm|mts|mtv|mxf|mxg|nsv|nuv|ogg|ogm|ogv|ogx|ps|rec|rm|rmvb|rpl|s3m|thp|tod|ts|tts|txd|vlc|vob|vro|webm|wm|wmv|wtv|xesc|xm)$"
#define kSupportedSubtitleFileExtensions @"\\.(cdg|idx|srt|sub|utf|ass|ssa|aqt|jss|psb|rt|smi|txt|smil|stl|usf|dks|pjs|mpl2|mks|vtt|ttml|dfxp)$"
#define kSupportedAudioFileExtensions @"\\.(3ga|669|a52|aa3|aac|ac3|adt|adts|aif|aifc|aiff|amb|amr|aob|ape|at3|au|awb|caf|dts|flac|it|kar|m4a|m4b|m4p|m5p|mid|mka|mlp|mod|mpa|mp1|mp2|mp3|mpc|mpga|mus|oga|ogg|oma|opus|qcp|ra|rmi|s3m|sid|spx|tak|thd|tta|voc|vqf|w64|wav|wma|wv|xa|xm)$"
#define kSupportedPlaylistFileExtensions @"\\.(asx|b4s|cue|ifo|m3u|m3u8|pls|ram|rar|sdp|vlc|xspf|wax|wvx|zip|conf)$"

#define kSupportedProtocolSchemes @"(rtsp|mms|mmsh|udp|rtp|rtmp|sftp|ftp|smb)$"

#define kVLCDarwinNotificationNowPlayingInfoUpdate @"org.videolan.ios-app.nowPlayingInfoUpdate"

#if TARGET_IPHONE_SIMULATOR
#define WifiInterfaceName @"en1"
#else
#define WifiInterfaceName @"en0"
#endif

#define kVLCMigratedToUbiquitousStoredServerList @"kVLCMigratedToUbiquitousStoredServerList"
#define kVLCStoredServerList @"kVLCStoredServerList"
#define kVLCStoreDropboxCredentials @"kVLCStoreDropboxCredentials"
#define kVLCStoreOneDriveCredentials @"kVLCStoreOneDriveCredentials"
#define kVLCStoreBoxCredentials @"kVLCStoreBoxCredentials"
#define kVLCStoreGDriveCredentials @"kVLCStoreGDriveCredentials"

#define kVLCUserActivityPlaying @"org.videolan.vlc-ios.playing"

#define kVLCApplicationShortcutLocalVideo @"ApplicationShortcutLocalVideo"
#define kVLCApplicationShortcutLocalAudio @"ApplicationShortcutLocalAudio"
#define kVLCApplicationShortcutNetwork @"ApplicationShortcutNetwork"
#define kVLCApplicationShortcutPlaylist @"ApplicationShortcutPlaylist"

#define kVLCWifiAuthentificationMaxAttempts 5
#define kVLCWifiAuthentificationSuccess 0
#define kVLCWifiAuthentificationFailure 1
#define kVLCWifiAuthentificationBanned 2

#define kVLCGroupLayout @"kVLCGroupLayout"

#define kVLCDonationAnonymousCustomerID @"kVLCDonationAnonymousCustomerID"

/* LEGACY KEYS, DO NOT USE IN NEW CODE */
#define kVLCFTPServer @"ftp-server"
#define kVLCFTPLogin @"ftp-login"
#define kVLCFTPPassword @"ftp-pass"
#define kVLCPLEXServer @"plex-server"
#define kVLCPLEXPort @"plex-port"
