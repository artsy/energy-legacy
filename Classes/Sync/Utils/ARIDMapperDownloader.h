//
// ARIDMapperDownloader
// Created by orta on 06/03/2014.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import <DRBOperationTree/DRBOperationTree.h>

@class ARDeleter;


@interface ARIDMapperDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter;

- (Class)classForRenderedObjects;

- (NSURLRequest *)urlRequestForIDsWithObject:(id)object;

- (NSURLRequest *)urlRequestForObjectWithID:(NSString *)objectID;

- (void)performWorkWithDownloadObject:(id)object;

@end
