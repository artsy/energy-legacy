//
// ARArtistDownloader
// Created by orta on 06/03/2014.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "ARArtistDownloader.h"
#import "ARRouter.h"


@interface ARArtistDownloader ()
@end


@implementation ARArtistDownloader

- (Class)classForRenderedObjects
{
    return Artist.class;
}

- (NSURLRequest *)urlRequestForIDsWithObject:(NSString *)partnerID
{
    return [ARRouter newArtistIDsRequestWithPartnerSlug:partnerID];
}

- (NSURLRequest *)urlRequestForObjectWithID:(NSString *)objectID
{
    return [ARRouter newArtistInfoRequestWithArtistID:objectID];
}

@end
