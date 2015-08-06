//
// ARArtistDocumentDownloader
// Created by orta on 06/03/2014.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "ARArtistDocumentDownloader.h"
#import "ARRouter.h"


@interface ARArtistDocumentDownloader ()
@property (readwrite, nonatomic, strong) Artist *artist;
@end


@implementation ARArtistDocumentDownloader

- (Class)classForRenderedObjects
{
    return ArtistDocument.class;
}

- (NSURLRequest *)urlRequestForIDsWithObject:(Artist *)artist
{
    self.artist = artist;
    return [ARRouter newArtistDocumentsRequestWithPartnerSlug:[Partner currentPartnerID] artistID:artist.slug];
}

- (NSURLRequest *)urlRequestForObjectWithID:(NSString *)objectID
{
    return [ARRouter newArtistDocumentInfoRequestWithPartnerSlug:[Partner currentPartnerID] artistID:self.artist.slug documentID:objectID];
}

@end
