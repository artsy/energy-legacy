#import <AFNetworking/AFHTTPClient.h>


@interface ARRouter : NSObject

+ (void)setup;
+ (void)setupWithBaseURL:(NSString *)baseURL;

+ (NSURL *)baseURL;
+ (void)setAuthToken:(NSString *)token;

+ (AFHTTPClient *)client;

+ (NSURLRequest *)requestForURL:(NSURL *)url;

/// Misc site
+ (NSURLRequest *)newArtsyPing;

/// User info
+ (NSURLRequest *)newUserInfoRequest;

/// Partner info
+ (NSURLRequest *)newPartnersRequest;

+ (NSURLRequest *)newPartnerSizeRequest:(NSString *)partnerSlug;

+ (NSURLRequest *)newPartnerInfoRequestWithID:(NSString *)partnerSlug;

+ (NSURLRequest *)newPartnerFullInfoRequestWithID:(NSString *)partnerSlug;

+ (NSURLRequest *)newSetPartnerOptionForKey:(NSString *)key value:(NSString *)value partnerID:(NSString *)partnerID;

/// Search for Admin
+ (NSURLRequest *)newSearchPartnersRequestWithQuery:(NSString *)query;

/// Artist
+ (NSURLRequest *)newArtistInfoRequestWithArtistID:(NSString *)artistID;

+ (NSURLRequest *)newArtistIDsRequestWithPartnerSlug:(NSString *)partnerSlug;

+ (NSURLRequest *)newArtistDocumentsRequestWithPartnerSlug:(NSString *)partnerSlug artistID:(NSString *)artistID;

+ (NSURLRequest *)newArtistDocumentInfoRequestWithPartnerSlug:(NSString *)partnerSlug artistID:(NSString *)artistID documentID:(NSString *)documentID;

/// Shows
+ (NSURLRequest *)newPartnerShowIDsRequestWithPartnerSlug:(NSString *)partnerSlug;

+ (NSURLRequest *)newPartnerShowRequestWithPartnerSlug:(NSString *)partnerSlug showID:(NSString *)showID;

+ (NSURLRequest *)newPartnerShowDocumentsRequestWithPartnerSlug:(NSString *)partnerSlug showID:(NSString *)showID;

+ (NSURLRequest *)newPartnerShowDocumentsInfoRequestWithPartnerSlug:(NSString *)partnerSlug showID:(NSString *)showID documentID:(NSString *)documentID;

+ (NSURLRequest *)newInstallationImagesRequestForShowWithID:(NSString *)showID page:(NSInteger)page;

+ (NSURLRequest *)newCoverImageRequestForShowWithID:(NSString *)showID page:(NSInteger)page;

/// Artworks
+ (NSURLRequest *)newAllArtworkIDsRequestWithPartnerSlug:(NSString *)partnerSlug;

+ (NSURLRequest *)newArtworkRequestForArtworkWithID:(NSString *)idString;

+ (NSURLRequest *)newArtworksRequestForShowWithID:(NSString *)showID page:(NSInteger)page partnerSlug:(NSString *)partnerSlug;

/// Albums
+ (NSURLRequest *)newAlbumIDsRequestWithPartnerSlug:(NSString *)partnerSlug;

+ (NSURLRequest *)newPartnerAlbumInfoRequestWithPartnerID:(NSString *)partnerID albumID:(NSString *)name;

+ (NSURLRequest *)newArtworksRequestForPartner:(NSString *)partnerID album:(NSString *)albumID page:(NSInteger)page;

+ (NSURLRequest *)newPartnerAlbumCreateAlbumRequestWithPartnerID:(NSString *)partnerID albumName:(NSString *)name;

+ (NSURLRequest *)newPartnerAlbumAddArtworkRequestWithPartnerID:(NSString *)partnerID albumID:(NSString *)albumID artworkID:(NSString *)artworkID;

+ (NSURLRequest *)newPartnerAlbumRemoveArtworkRequestWithPartnerID:(NSString *)partnerID albumID:(NSString *)albumID artworkID:(NSString *)artworkID;


/// Image lookup
+ (NSURL *)fullURLForImage:(NSString *)urlString;

/// Locations
+ (NSURLRequest *)newLocationIDsRequestWithPartnerSlug:(NSString *)partnerSlug;
+ (NSURLRequest *)newPartnerLocationRequestWithPartnerID:(NSString *)partnerID locationID:(NSString *)locationID;
+ (NSURLRequest *)newPartnerLocationArtworksRequestWithPartnerID:(NSString *)partnerID locationID:(NSString *)locationID page:(NSInteger)page;

@end
