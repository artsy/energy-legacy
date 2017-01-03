// General
NSString *const ARFeedErrorKey = @"error";
NSString *const ARHerokuErrorKey = @"backtrace";
NSString *const ARPartnerKey = @"partner";

// Auth
NSString *const AROAuthTokenKey = @"access_token";
NSString *const AROAuthTokenExpiryDateKey = @"expires_in";

// Artworks
NSString *const ARFeedIDKey = @"id";
NSString *const ARFeedSlugKey = @"slug";
NSString *const ARFeedTitleKey = @"title";
NSString *const ARFeedDisplayTitleKey = @"display";
NSString *const ARFeedArtistKey = @"artist";
NSString *const ARFeedArtistsKey = @"artists";

NSString *const ARFeedNameKey = @"name";
NSString *const ARFeedCategoryKey = @"category";
NSString *const ARFeedMediumKey = @"medium";
NSString *const ARFeedSeriesKey = @"series";
NSString *const ARFeedSaleStateKey = @"forsale";
NSString *const ARFeedDateKey = @"date";
NSString *const ARFeedMetricKey = @"metric";
NSString *const ARFeedWidthKey = @"width";
NSString *const ARFeedHeightKey = @"height";
NSString *const ARFeedDepthKey = @"depth";
NSString *const ARFeedDiameterKey = @"diameter";
NSString *const ARFeedDimensionsKey = @"dimensions";
NSString *const ARFeedDimensionsInchesKey = @"in";
NSString *const ARFeedDimensionsCMKey = @"cm";
NSString *const ARFeedCollaboratorsKey = @"collaborators";
NSString *const ARFeedPriceKey = @"price";
NSString *const ARFeedInternalPriceKey = @"internal_display_price";
NSString *const ARFeedPriceHiddenStateKey = @"price_hidden";
NSString *const ARFeedPartnerIDKey = @"partner_id";
NSString *const ARFeedArtworkInfoKey = @"additional_information";
NSString *const ARFeedProvenanceKey = @"provenance";
NSString *const ARFeedShowHistoryKey = @"exhibition_history";
NSString *const ARFeedImagesKey = @"images";
NSString *const ARFeedPublishedKey = @"published";
NSString *const ARFeedArtworkEditionsKey = @"editions";
NSString *const ARFeedArtworkEditionSetsKey = @"edition_sets";
NSString *const ARFeedAvailabilityKey = @"availability";
NSString *const ARFeedSignatureKey = @"signature";
NSString *const ARFeedLiteratureKey = @"literature";
NSString *const ARFeedImageRightsKey = @"image_rights";
NSString *const ARFeedInventoryIDKey = @"inventory_id";
NSString *const ARFeedConfidentialNotesKey = @"confidential_notes";

// Edition Sets
NSString *const ARFeedEditionSetArtistProofsKey = @"artist_proofs";
NSString *const ARFeedEditionSetAvailableEditionsKey = @"available_editions";
NSString *const ARFeedDurationKey = @"duration";
NSString *const ARFeedEditionSetEditionSizeKey = @"edition_size";
NSString *const ARFeedEditionSetPrototypesKey = @"prototypes";

// Images
NSString *const ARFeedImageSourceKey = @"image_url";
NSString *const ARFeedImageSizeSmallKey = @"small";
NSString *const ARFeedImageSizeMediumKey = @"medium";
NSString *const ARFeedImageSizeSquareKey = @"square";
NSString *const ARFeedImageSizeLargeKey = @"large";
NSString *const ARFeedImageSizeLargerKey = @"larger";
NSString *const ARFeedImageIsMainImageKey = @"is_default";
NSString *const ARFeedArtworkIDKey = @"artwork_id";
NSString *const ARFeedImageAspectRatioKey = @"aspect_ratio";
NSString *const ARFeedImageVersionsKey = @"image_versions";
NSString *const ARFeedImageOriginalHeightKey = @"original_height";
NSString *const ARFeedImageOriginalWidthKey = @"original_width";
NSString *const ARFeedImagePositionKey = @"position";
NSString *const ARFeedCaptionKey = @"caption";

// Image tiling
NSString *const ARFeedMaxTiledHeightKey = @"max_tiled_height";
NSString *const ARFeedMaxTiledWidthKey = @"max_tiled_width";
NSString *const ARFeedTileSizeKey = @"tile_size";
NSString *const ARFeedTileOverlapKey = @"tile_overlap";
NSString *const ARFeedTileBaseUrlKey = @"tile_base_url";
NSString *const ARFeedTileFormatKey = @"tile_format";

// Artist
NSString *const ARFeedYearsKey = @"years";
NSString *const ARFeedDeathDateKey = @"deathday";
NSString *const ARFeedFirstNameKey = @"first";
NSString *const ARFeedMiddleNameKey = @"middle";
NSString *const ARFeedLastNameKey = @"last";
NSString *const ARFeedDisplayNameKey = @"display_name";
NSString *const ARFeedAwardsKey = @"awards";
NSString *const ARFeedBlurbKey = @"blurb";
NSString *const ARFeedHometownKey = @"hometown";
NSString *const ARFeedBiographyKey = @"biography";
NSString *const ARFeedNationalityKey = @"nationality";
NSString *const ARFeedStatementKey = @"statement";
NSString *const ARFeedSortableIDKey = @"sortable_id";

// Album
NSString *const ARFeedPrivateStateKey = @"private";
NSString *const ARFeedSummaryKey = @"description";
NSString *const ARFeedArtworksKey = @"artworks";

// Document
NSString *const ARFeedDocumentSize = @"size";
NSString *const ARFeedDocumentURL = @"uri";
NSString *const ARFeedDocumentFileName = @"filename";
NSString *const ARFeedDocumentSlug = @"id";
NSString *const ARFeedPartnerShowKey = @"partner_show";

// Partner
NSString *const ARFeedPartnerGivenNameKey = @"given_name";
NSString *const ARFeedWebsiteKey = @"website";
NSString *const ARFeedEmailKey = @"email";
NSString *const ARFeedArtworksCountKey = @"artworks_count";
NSString *const ARFeedArtistDocumentsCountKey = @"artist_documents_count";
NSString *const ARFeedArtistsCountKey = @"artists_count";
NSString *const ARFeedTypeKey = @"type";
NSString *const ARFeedHasFullProfileKey = @"has_full_profile";
NSString *const ARFeedHasDefaultProfileIDKey = @"default_profile_id";
NSString *const ARFeedDefaultProfilePublicKey = @"default_profile_public";
NSString *const ARFeedHasLimitedPartnerToolAccessKey = @"has_limited_partner_tools_access";
NSString *const ARFeedPartnerFlagsKey = @"partner_flags";
NSString *const ARFeedRelativeSizeKey = @"relative_size";
NSString *const ARFeedPartnerAdminKey = @"admin";
NSString *const ARFeedRegionKey = @"region";
NSString *const ARFeedPartnerSubscriptionPlansNameKey = @"subscription_plans_names";
NSString *const ARFeedPartnerSubscriptionStateKey = @"subscription_state";
NSString *const ARFeedShowDocumentsCountKey = @"partner_show_documents_count";
NSString *const ARFeedPartnerContractTypeKey = @"contract_type";
NSString *const ARFeedPartnerRawIDKey = @"_id";
NSString *const ARFeedPartnerIsFoundingPartnerKey = @"founding_partner";


// Show
NSString *const ARFeedStartAtKey = @"start_at";
NSString *const ARFeedEndAtKey = @"end_at";
NSString *const ARFeedLocationKey = @"location";
NSString *const ARFeedStatusKey = @"status";

// Location
NSString *const ARFeedAddressKey = @"address";
NSString *const ARFeedAddress2Key = @"address2";
NSString *const ARFeedCityKey = @"city";
NSString *const ARFeedGeoPointKey = @"geo_point";
NSString *const ARFeedPhoneKey = @"phone";
NSString *const ARFeedPostalCodeKey = @"postal_code";
NSString *const ARFeedStateKey = @"state";

//Availabilities
NSString *const ARAvailabilityForSale = @"for sale";
NSString *const ARAvailabilityNotForSale = @"not for sale";
NSString *const ARAvailabilitySold = @"sold";
NSString *const ARAvailabilityOnHold = @"on hold";
