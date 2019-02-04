// Notification names

// New Sync notifications
NSString *const ARLargeImageDownloadCompleteNotification = @"ARLargeImageDownloadCompleteNotification";
NSString *const ARAllArtworksDownloadedNotification = @"ARAllArtworksDownloadedNotification";

NSString *const ARSyncStartedNotification = @"ARSyncStartedNotification";
NSString *const ARSyncFinishedNotification = @"ARSyncFinishedNotification";

NSString *const ARUserDidChangeDimensionTypeNotification = @"ARUserDidChangeDimensionTypeNotification";
NSString *const ARUserDidChangeGridFilteringSettingsNotification = @"ARUserDidChangeHiddenPublishedNotification";
NSString *const ARUserDidChangeHidePricesNotification = @"ARUserDidChangeHidePricesNotification";

NSString *const ARAlbumDataChanged = @"ARAlbumDataChanged";
NSString *const ARAlbumRemoveAlbumNotification = @"ARAlbumRemoveItemNotification";
NSString *const ARAlbumHighlightAlbumItemNotification = @"ARAlbumHighlightAlbumItemNotification";

NSString *const ARPartnerUpdatedNotification = @"ARPartnerUpdatedNotification";
NSString *const ARUserUpdatedNotification = @"ARUserUpdatedNotification";
NSString *const ARArtworkAvailabilityUpdated = @"ARArtworkAvailabilityUpdated";

NSString *const ARGridSelectionChangedNotification = @"ARGridSelectionChangedNotification";

NSString *const ARArtworkEnsureShowingMetadataNotification = @"ARArtworkEnsureShowingMetadataNotification";
NSString *const ARToggleArtworkInfoNotification = @"ARToggleArtworkInfoNotification";
NSString *const ARShowArtworkInfoNotification = @"ARShowArtworkInfoNotification";
NSString *const ARHideArtworkInfoNotification = @"ARHideArtworkInfoNotification";

NSString *const ARShowSecondaryArtworkInfoNotification = @"ARShowSecondaryArtworkInfoNotification";
NSString *const ARHideSecondaryArtworkInfoNotification = @"ARHideSecondaryArtworkInfoNotification";

NSString *const ARNotEnoughDiskSpaceNotification = @"ARNotEnoughDiskSpaceNotification";

NSString *const ARDismissAllPopoversNotification = @"ARDismissAllPopoversNotification";

NSString *const ARApplicationDidGoIntoBackground = @"ARApplicationDidGoIntoBackground";

// User info key names
NSString *const AROAuthTokenNotificationKey = @"AROAuthTokenNotificationKey";
NSString *const AROAuthTokenExpiryDateNotificationKey = @"AROAuthTokenExpiryDateNotificationKey";
NSString *const ARAlbumIndexPathKey = @"ARAlbumIndexPathKey";
NSString *const ARAlbumItemKey = @"ARAlbumItemKey";
