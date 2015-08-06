extern NSString *const ARSyncStartEvent;
extern NSString *const ARManualSyncStartEvent;
extern NSString *const ARSyncHaltedDueToSpaceEvent;
extern NSString *const ARSyncFinishedEvent;

extern NSString *const ARAddToAlbumEvent;
extern NSString *const ARRemoveFromAlbumEvent;
extern NSString *const ARSetCoverEvent;
extern NSString *const ARSelectArtworkEvent;

extern NSString *const AREmailComposeEvent;
extern NSString *const AREmailCancelledEvent;
extern NSString *const AREmailSentEvent;

extern NSString *const ARArtistViewEvent;
extern NSString *const ARArtistActionButtonEvent;
extern NSString *const ARArtistActionSelectArtworkEvent;

extern NSString *const ARAlbumViewEvent;
extern NSString *const ARAlbumActionButtonEvent;
extern NSString *const ARAlbumActionSelectArtworkEvent;
extern NSString *const ARAlbumAddToSelfEvent;
extern NSString *const ARNewAlbumEvent;
extern NSString *const ARDeleteAlbumEvent;
extern NSString *const ARRenameAlbumEvent;

extern NSString *const ARArtworkViewEvent;
extern NSString *const ARZoomEvent;
extern NSString *const ARArtworkViewInRoomEvent;
extern NSString *const ARArtworkMoreInfoEvent;

extern NSString *const ARCollectionsViewEvent;
extern NSString *const ARAlbumsEditEvent;

extern NSString *const ARArtistsViewEvent;
extern NSString *const ARShowsViewEvent;

extern NSString *const ARDocumentViewEvent;

extern NSString *const ARDisplaySettingsChange;
extern NSString *const AREmailSettingsChangeEvent;

extern NSString *const ARSearchTabEvent;
extern NSString *const ARSearchSelectArtistEvent;
extern NSString *const ARSearchSelectAlbumEvent;
extern NSString *const ARSearchSelectArtworkEvent;
extern NSString *const ARSearchSelectShowEvent;
extern NSString *const ARSearchSelectLocationEvent;

extern NSString *const ARSession;
extern NSString *const ARSessionStarted;
extern NSString *const ARNoPartnersEvent;

extern NSString *const ARDocumentPopoverOpenedEvent;
extern NSString *const ARSearchFieldFocusedEvent;
extern NSString *const ARSettingsPopoverOpenedEvent;
extern NSString *const ARArtworkViewChromeHiddenEvent;
extern NSString *const ARLogoutEvent;
extern NSString *const ARLockoutEvent;
extern NSString *const ARZeroStateEvent;

// to be used as "from" properties for events that
// can be triggered from multiple places
extern NSString *const ARAlbumPage;
extern NSString *const ARAllAlbumsPage;
extern NSString *const ARAllArtistsPage;
extern NSString *const ARAllShowsPage;
extern NSString *const ARAllLocationsPage;

extern NSString *const ARArtistPage;
extern NSString *const ARArtworkPage;
extern NSString *const ARShowPage;
