//
// ARPagingIDDownloaderOperation
// Created by orta on 3/26/14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

/**
 *  Supports paging through a collection of JSON resources. Either can
 *  pass back the IDs for them all, or pass back the full JSON representation.
 *
 *  @note this starts with index 1, not 0!
 */


@interface ARPagingDownloaderOperation : NSOperation

@property (readwrite, nonatomic, copy) NSURLRequest * (^requestWithPage)(NSInteger);

/// Use this to get IDs for objects sent back to you
@property (readwrite, nonatomic, copy) void (^onCompletionWithIDs)(NSSet *);

/// Or use this to get dictionaries sent back to you
@property (readwrite, nonatomic, copy) void (^onCompletionWithJSONDictionaries)(NSSet *);

@property (readwrite, nonatomic, copy) void (^failure)();

@end
