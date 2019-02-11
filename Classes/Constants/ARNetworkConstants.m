NSString *const ARAuthHeader = @"X-Access-Token";

NSString *const ARBaseURL = @"https://api.artsy.net";
NSString *const ARBaseCMSURL = @"https://cms.artsy.net";

NSString *const ARStaticBaseURL = @"http://static.artsy.net";

NSString *const ARSiteUpURL = @"/api/v1/system/ping";


NSString *const ARArtworkURLFormat = @"/api/v1/artwork/%@";
NSString *const ARArtworkEditionSetURLFormat = @"/api/v1/artwork/%@/edition_set/%@";
NSString *const ARMyPartnersURL = @"/api/v1/me/partners";
NSString *const ARSearchPartnersURL = @"/api/v1/match/partners";

NSString *const ARMyInfoURL = @"/api/v1/me";
NSString *const ARPartnerInfoURLFormat = @"/api/v1/partner/%@";
NSString *const ARPartnerInfoFullURLFormat = @"/api/v1/partner/%@/all";
NSString *const ARPartnerFlagsURLFormat = @"/api/v1/partner/%@/partner_flags";

NSString *const ARPartnerSizeURL = @"/api/v1/partner/%@/size";

NSString *const ARArtistURLFormat = @"/api/v1/artist/%@";
NSString *const ARPartnerArtistsURLFormat = @"/api/v1/partner/%@/artists";
NSString *const ARPartnerArtistDocumentsURLFormat = @"/api/v1/partner/%@/artist/%@/documents";
NSString *const ARPartnerArtistDocumentURLFormat = @"/api/v1/partner/%@/artist/%@/document/%@";

NSString *const ARPartnerAlbumURLFormat = @"/api/v1/partner/%@/album/%@";
NSString *const ARPartnerAlbumsURLFormat = @"/api/v1/partner/%@/albums";
NSString *const ARPartnerAlbumArtworksURLFormat = @"/api/v1/partner/%@/album/%@/artworks";

NSString *const ARPartnerLocationURLFormat = @"/api/v1/partner/%@/location/%@";
NSString *const ARPartnerLocationsURLFormat = @"/api/v1/partner/%@/locations";
NSString *const ARPartnerLocationArtworksURLFormat = @"/api/v1/partner/%@/artworks/all";

NSString *const ARPartnerShowsURLFormat = @"/api/v1/partner/%@/shows";
NSString *const ARPartnerShowURLFormat = @"/api/v1/partner/%@/show/%@";
NSString *const ARPartnerShowArtworksURLFormat = @"/api/v1/partner/%@/show/%@/artworks";
NSString *const ARPartnerShowImagesURLFormat = @"/api/v1/partner_show/%@/images";
NSString *const ARPartnerShowDocumentsURLFormat = @"/api/v1/partner/%@/show/%@/documents";
NSString *const ARPartnerShowDocumentURLFormat = @"/api/v1/partner/%@/show/%@/document/%@";

NSString *const ARPartnerArtworkIdsURLFormat = @"/api/v1/partner/%@/artworks";
